import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Static Properties
    
    private struct Constants {
        static let itemsPerRow: CGFloat = 2
        static let itemsSpacing: CGFloat = 20
        static let collectionViewCellReuseIdentifier = "SlotCollectionViewCell"
    }
    
    // MARK: - Injections
    
    private var viewModel: MainViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [unowned self] viewModel in
                mainView.updateChoosenSlotsListIndex(viewModel.getChoosenCategoryIndex())
                mainView.slotsCollectionView.reloadData()
            }
            mainView.updateSlotsList(categories: viewModel.getCategoryNames())
            mainView.updateChoosenSlotsListIndex(viewModel.getChoosenCategoryIndex())
            mainView.accountLabel.text = "\(viewModel.getAccount())"
        }
    }
    
    // MARK: - Private Properties
    
    private var mainView = MainView()
    
    // MARK: - View Controller Lifecycle
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.setupView()
        mainView.slotsCollectionView.reloadData()
        AppUtility.instance.lockOrientation(.allButUpsideDown)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mainView.slotsCollectionView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        mainView.delegate = self
        setupSlotsCollectionView()
    }
    
    private func setupSlotsCollectionView() {
        mainView.slotsCollectionView.delegate = self
        mainView.slotsCollectionView.dataSource = self
        mainView.slotsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCellReuseIdentifier)
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slotsCollectionViewSwipe(_:)))
        leftSwipeGestureRecognizer.direction = .left
        mainView.slotsCollectionView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(slotsCollectionViewSwipe(_:)))
        rightSwipeGestureRecognizer.direction = .right
        mainView.slotsCollectionView.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc private func slotsCollectionViewSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            updateChoosenSlotsListIndex(viewModel.getChoosenCategoryIndex() + 1)
        case .right:
            updateChoosenSlotsListIndex(viewModel.getChoosenCategoryIndex() - 1)
        default:
            return
        }
    }
    
    private func updateChoosenSlotsListIndex(_ newIndex: Int) {
        let lastIndex = viewModel.getChoosenCategoryIndex()
        let success = viewModel.setChoosenCategoryIndex(newIndex)
        if success { swipeSlotsCollectionViewAnimate(newIndex > lastIndex) }
        
    }
    
    private func swipeSlotsCollectionViewAnimate(_ isLeftSide: Bool) {
        let transition = CATransition()
        transition.startProgress = 0.0
        transition.endProgress = 1.0
        transition.type = .push
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.subtype = isLeftSide ? .fromRight : .fromLeft
        transition.duration = 0.15

        mainView.slotsCollectionView.layer.add(transition, forKey: nil)
    }
    
    private func navigateToGameViewController(slotType: SlotType) {
        AppUtility.instance.lockOrientation(.landscape)
        let gameViewController = GameViewController()
        gameViewController.viewModel = GameViewModel(slotType: slotType)
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
}

// MARK: - Main View Delegate

extension MainViewController: MainViewDelegate {
    
    func choosenSlotsListIndexWasChanged(_ mainView: MainView) {
        updateChoosenSlotsListIndex(mainView.slotsListSegmentedControlView.selectedSegmentIndex)
    }
    
}

// MARK: - Collection View Delegate & Collection View Data Source

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSlotsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellReuseIdentifier, for: indexPath)
        let backgroundView = UIImageView(image: viewModel.getChoosenCategory().slots[indexPath.row].image)
        backgroundView.cornerRadius = 12
        backgroundView.contentMode = .scaleAspectFill
        cell.backgroundView = backgroundView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToGameViewController(slotType: viewModel.getChoosenCategory().slots[indexPath.row])
    }
    
}

// MARK: - Collection View Delegate Flow Layout

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemsSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemsSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.itemsSpacing * (Constants.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let sideSize = availableWidth / Constants.itemsPerRow
        return viewModel.getChoosenCategory().slots[indexPath.row].isWideCard ? CGSize(width: collectionView.frame.width, height: sideSize) : CGSize(width: sideSize, height: sideSize)
    }
    
}
