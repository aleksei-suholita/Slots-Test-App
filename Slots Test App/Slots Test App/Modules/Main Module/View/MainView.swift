import UIKit
import Then
import SnapKit
import SwifterSwift

final class MainView: UIView {
    
    // MARK: - Injections
    
    weak var delegate: MainViewDelegate?
    
    // MARK: - UI
    
    var userImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "user-image")
        $0.cornerRadius = 24
    }
    
    var chestImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "chest-image")!
    }
    
    var accountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "0"
        $0.font = UIFont(name: Constants.Design.FontName.robotoBold, size: 18)!
    }
    
    var accountLabelBackgroundView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Constants.Design.Color.lightBackground
        $0.cornerRadius = 4
    }
    
    var slotsView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Constants.Design.Color.darkBackground
        $0.cornerRadius = 24
    }
    
    var slotsListControlContainerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var slotsListSegmentedControlView = UISegmentedControl().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.selectedSegmentTintColor = Constants.Design.Color.darkBackground
        let clearBackgroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        $0.setBackgroundImage(clearBackgroundImage, for: .normal, barMetrics: .default)
        $0.setDividerImage(clearBackgroundImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ], for: .selected)
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#717076")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ], for: .normal)
        
        $0.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private var slotsSegmentedControlUnderlineView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hexString: "#EA4141")!
        $0.cornerRadius = 2
    }
    
    var slotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then { $0.scrollDirection = .vertical }).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    private lazy var slotsSegmentedControlUnderlineViewLeadingConstraint: NSLayoutConstraint = {
        return slotsSegmentedControlUnderlineView.leftAnchor.constraint(equalTo: slotsListSegmentedControlView.leftAnchor)
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Instance Methods
    
    func setupView() {
        backgroundColor = Constants.Design.Color.background
        updateSegmentedControlLinePosition()
    }
    
    func updateSlotsList(categories: [String]) {
        slotsListSegmentedControlView.removeAllSegments()
        for segmentIndex in 0..<categories.count {
            slotsListSegmentedControlView.insertSegment(withTitle: categories[segmentIndex], at: segmentIndex, animated: true)
        }
    }
    
    func updateChoosenSlotsListIndex(_ index: Int) {
        slotsListSegmentedControlView.selectedSegmentIndex = index
        updateSegmentedControlLinePosition()
    }
    
    func updateSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(slotsListSegmentedControlView.selectedSegmentIndex) + 1
        let segmentWidth = slotsListSegmentedControlView.frame.width / CGFloat(max(slotsListSegmentedControlView.numberOfSegments, 1))
        let leadingDistance = segmentWidth * segmentIndex - segmentWidth / 2 - slotsSegmentedControlUnderlineView.frame.width / 2
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.slotsSegmentedControlUnderlineViewLeadingConstraint.constant = leadingDistance
            self?.layoutIfNeeded()
        })
    }
    
    // MARK: - Private Methods
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.choosenSlotsListIndexWasChanged(self)
    }
    
    private func addSubviews() {
        addSubview(userImageView)
        addSubview(accountLabelBackgroundView)
        addSubview(chestImageView)
        accountLabelBackgroundView.addSubview(accountLabel)
        addSubview(slotsView)
        slotsView.addSubview(slotsListControlContainerView)
        slotsListControlContainerView.addSubview(slotsListSegmentedControlView)
        slotsListControlContainerView.addSubview(slotsSegmentedControlUnderlineView)
        slotsView.addSubview(slotsCollectionView)
    }
    
    private func setupConstraints() {
        userImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(48)
            maker.top.equalToSuperview().offset(48)
            maker.leading.equalToSuperview().offset(32)
        }
        
        accountLabelBackgroundView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-32)
            maker.centerY.equalTo(userImageView)
        }
        
        accountLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(-4)
            maker.trailing.equalToSuperview().offset(-12)
            maker.leading.equalToSuperview().offset(20)
        }

        chestImageView.snp.makeConstraints { maker in
            maker.trailing.equalTo(accountLabelBackgroundView.snp.leading).offset(16)
            maker.centerY.equalTo(accountLabelBackgroundView)
            maker.height.equalTo(48)
        }
        
        slotsView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(24)
            maker.top.equalTo(userImageView.snp.bottom).offset(32)
        }
        
        slotsListControlContainerView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(24)
        }
        
        slotsListSegmentedControlView.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
        }
        
        slotsSegmentedControlUnderlineView.snp.makeConstraints { maker in
            maker.top.equalTo(slotsListSegmentedControlView.snp.bottom)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(4)
            maker.width.equalTo(slotsListSegmentedControlView.snp.width).dividedBy(CGFloat(max(slotsListSegmentedControlView.numberOfSegments, 1)) * 4)
        }
        slotsSegmentedControlUnderlineViewLeadingConstraint.isActive = true
        
        slotsCollectionView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(32)
            maker.trailing.equalToSuperview().offset(-32)
            maker.top.equalTo(slotsListControlContainerView.snp.bottom).offset(32)
        }
    }
}

protocol MainViewDelegate: AnyObject {
    
    func choosenSlotsListIndexWasChanged(_ mainView: MainView)
    
}
