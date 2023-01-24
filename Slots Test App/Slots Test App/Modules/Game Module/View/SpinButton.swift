import SpriteKit

final class SpinButton: SKSpriteNode {
    
    // MARK: - Injections
    
    weak var delegate: SpinButtonDelegate?
    
    // MARK: - UI
    
    private var circleShapeNode = SKShapeNode(circleOfRadius: 53.5).then {
        $0.fillColor = UIColor(hexString: "#EA4141", transparency: 0.4)!
        $0.strokeColor = .clear
    }
    
    private var spinLabel = SKLabelNode().then {
        $0.fontName = Constants.Design.FontName.robotoBold
        $0.fontSize = 38
        $0.text = "SPIN"
    }
    
    private var arrowsNode = SKSpriteNode(imageNamed: "circle-arrows.png")
    
    // MARK: - Sprite Node Lifecycle
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 128, height: 128))
        addChilds()
        updateLayout()
        setupNode()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Touches
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateArrows()
        delegate?.spinButtonWasTapped(self)
    }
    
    // MARK: - Private Methods
    
    private func addChilds() {
        addChild(circleShapeNode)
        addChild(spinLabel)
        addChild(arrowsNode)
    }
    
    private func updateLayout() {
        spinLabel.position = CGPoint(x: 0, y: -spinLabel.frame.height / 2)
    }
    
    private func setupNode() {
        isUserInteractionEnabled = true
    }
    
    private func animateArrows() {
        let rotateAction = SKAction.rotate(byAngle: -.pi, duration: 0.5)
        rotateAction.timingMode = .easeInEaseOut
        arrowsNode.run(rotateAction)
    }
}

protocol SpinButtonDelegate: AnyObject {
    
    func spinButtonWasTapped(_ spinButton: SpinButton)
    
}
