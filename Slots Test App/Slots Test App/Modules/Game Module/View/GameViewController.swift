import UIKit
import SpriteKit
import SnapKit

final class GameViewController: UIViewController {
    
    // MARK: - Injections
    
    var viewModel: GameViewModelProtocol! {
        didSet {
            viewModel.viewModelDidChange = { [unowned self] viewModel in
                slotScene.stepperNode.valueLabelText = "\(viewModel.bet)"
                slotScene.accountNode.accountLabelText = "\(viewModel.getAccount())"
                slotScene.winLabel.text = viewModel.lastGameText
                slotScene.slotsGrid.reloadGrid()
            }
        }
    }
    
    // MARK: - Private Properties
    
    lazy private var slotScene = SlotScene(size: CGSize(width: max(view.frame.size.height, view.frame.size.width), height: min(view.frame.size.height, view.frame.size.width)))
    private var slotView = SKView()
    
    // MARK: - View / Object Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        navigationItem.setHidesBackButton(true, animated: false)
        slotScene.homeButtonDelegate = self
        slotScene.stepperNode.delegate = self
        slotScene.spinButton.delegate = self
        slotScene.slotsGrid.delegate = self
        view.addSubview(slotView)
        slotView.snp.makeConstraints { $0.edges.equalToSuperview() }
        slotScene.stepperNode.valueLabelText = "\(viewModel.bet)"
        slotScene.accountNode.accountLabelText = "\(viewModel.getAccount())"
        slotScene.slotsGrid.reloadGrid()
        slotView.presentScene(slotScene)
    }
    
}

// MARK: - Stepper Node Delegate

extension GameViewController: StepperNodeDelegate {
    
    func minusButtonWasPressed(_ stepper: StepperNode) {
        viewModel.updateBet(isPlus: false)
    }
    
    func plusButtonWasPressed(_ stepper: StepperNode) {
        viewModel.updateBet(isPlus: true)
    }
    
}

// MARK: - Spin Button Delegate

extension GameViewController: SpinButtonDelegate {
    
    func spinButtonWasTapped(_ spinButton: SpinButton) {
        viewModel.spin()
    }
    
}

// MARK: - Home Button Delegate

extension GameViewController: HomeButtonDelegate {
    
    func homeWasPressed() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Slots Grid Delegate

extension GameViewController: SlotsGridDelegate {
    
    func numberOfRows(_ slotsGrid: SlotsGrid) -> Int {
        return viewModel.getNumberRows()
    }
    
    func numberOfColumns(_ slotsGrid: SlotsGrid) -> Int {
        return viewModel.getNumberColumns()
    }
    
    func imageNameForCell(at index: IndexPath) -> String {
        return viewModel.imageNameForCell(at: index)
    }
    
}
