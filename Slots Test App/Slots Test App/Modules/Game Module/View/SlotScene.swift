import SpriteKit

final class SlotScene: SKScene {
    
    // MARK: - Injections
    
    weak var homeButtonDelegate: HomeButtonDelegate?
    
    // MARK: - UI
    
    lazy var backgroundImage = SKSpriteNode(texture: SKTexture(imageNamed: "Slot Background"), size: frame.size)
    var homeButton = SKSpriteNode(texture: SKTexture(imageNamed: "home"), size: CGSize(width: 24, height: 24))

    lazy var sideMenu = SKSpriteNode(texture: nil, size: CGSize(width: frame.width * 0.25, height: frame.height))
    lazy var sideMenuBackground = SKShapeNode(rectOf: sideMenu.size).then {
        $0.strokeColor = .clear
        $0.fillColor = UIColor(hexString: "#151418", transparency: 0.5)!
        $0.path = UIBezierPath(roundedRect: $0.frame, byRoundingCorners: .bottomLeft, cornerRadii: CGSize(width: 80, height: 80)).cgPath
    }
    
    var spinButton = SpinButton()
    lazy var accountNode = AccountNode(size: CGSize(width: sideMenu.frame.width * 0.7, height: sideMenu.frame.width * 0.55))
    lazy var stepperNode = StepperNode(size: CGSize(width: sideMenu.frame.width * 0.7, height: sideMenu.frame.width * 0.135))
    lazy var slotsGrid = SlotsGrid(size: CGSize(width: frame.width * 0.55, height: frame.height * 0.7))
    
    var winLabel = SKLabelNode(text: "WIN: 0").then {
        $0.fontSize = 22
        $0.fontColor = UIColor(hexString: "#FFFFFF")
        $0.fontName = Constants.Design.FontName.robotoBold
    }
    
    // MARK: - SKScene Lifecycle
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChilds()
        updateLayout()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if homeButton.contains(location) { homeButtonDelegate?.homeWasPressed() }
    }
    
    // MARK: - Instance Methods
    
    func updateLayout() {
        homeButton.position = CGPoint(x: -frame.width / 2 + 32 + homeButton.frame.width / 2, y: frame.height / 2 - 24 - homeButton.frame.height / 2)
        sideMenu.position = CGPoint(x: frame.width / 2 - sideMenu.frame.width / 2, y: 0)
        accountNode.position = CGPoint(x: 0, y: sideMenu.frame.height / 2 - accountNode.frame.height / 2 - 20)
        stepperNode.position = CGPoint(x: 0, y: -sideMenu.frame.height / 2 + stepperNode.frame.height / 2 + 32)
        spinButton.position = CGPoint(x: 0, y: (accountNode.position.y - accountNode.frame.height / 2 + stepperNode.position.y + stepperNode.frame.height / 2) / 2)
        slotsGrid.position = CGPoint(x: (homeButton.position.x + homeButton.frame.width / 2 + sideMenu.position.x - sideMenu.frame.width / 2) / 2, y: 0)
        winLabel.position = CGPoint(x: slotsGrid.position.x, y: -frame.height / 2 + winLabel.frame.height + 32)
    }
    
    // MARK: - Private Methods
    
    private func addChilds() {
        addChild(backgroundImage)
        addChild(homeButton)
        addChild(sideMenu)
        sideMenu.addChild(sideMenuBackground)
        sideMenu.addChild(accountNode)
        sideMenu.addChild(spinButton)
        sideMenu.addChild(stepperNode)
        addChild(slotsGrid)
        addChild(winLabel)
    }
    
}

protocol HomeButtonDelegate: AnyObject {
    
    func homeWasPressed()
    
}
