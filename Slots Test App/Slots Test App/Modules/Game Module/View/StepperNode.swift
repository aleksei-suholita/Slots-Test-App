import SpriteKit

final class StepperNode: SKSpriteNode {
    
    // MARK: - Injections
    
    weak var delegate: StepperNodeDelegate?
    
    // MARK: - Instance Properties
    
    var valueLabelText = "50" {
        didSet {
            valueLabel.text = valueLabelText
            updateLayout()
        }
    }
    
    // MARK: - UI
    
    private lazy var minusButtonNode = SKSpriteNode(texture: nil, size: CGSize(width: frame.height, height: frame.height))
    
    private lazy var minusButtonBackground = SKShapeNode(rectOf: CGSize(width: frame.height, height: frame.height), cornerRadius: frame.height / 8).then {
        $0.fillColor = UIColor(hexString: "#2B2836")!
        $0.strokeColor = UIColor(hexString: "#EA4141")!
    }
    
    private var plusLabel = SKLabelNode(text: "+").then {
        $0.fontName = Constants.Design.FontName.robotoBold
        $0.fontColor = UIColor(hexString: "#FFFFFF")
        $0.verticalAlignmentMode = .bottom
    }
    
    private lazy var plusButtonNode = SKSpriteNode(texture: nil, size: CGSize(width: frame.height, height: frame.height))
    
    private lazy var plusButtonBackground = SKShapeNode(rectOf: CGSize(width: frame.height, height: frame.height), cornerRadius: frame.height / 8).then {
        $0.fillColor = UIColor(hexString: "#2B2836")!
        $0.strokeColor = UIColor(hexString: "#EA4141")!
    }
    
    private var minusLabel = SKLabelNode(text: "-").then {
        $0.fontName = Constants.Design.FontName.robotoBold
        $0.fontColor = UIColor(hexString: "#FFFFFF")
        $0.verticalAlignmentMode = .bottom
    }
    
    private lazy var valueNode = SKSpriteNode(texture: nil, size: CGSize(width: frame.width - frame.height * 2 - 16, height: frame.height))
    
    private lazy var valueBackground = SKShapeNode(rectOf: CGSize(width: frame.width - frame.height * 2 - 16, height: frame.height), cornerRadius: frame.height / 8).then {
        $0.fillColor = UIColor(hexString: "#2B2836")!
        $0.strokeColor = UIColor(hexString: "#EA4141")!
    }
    
    private var valueLabel = SKLabelNode(text: "0").then {
        $0.fontName = Constants.Design.FontName.robotoBold
        $0.fontColor = UIColor(hexString: "#FFFFFF")
    }
    
    // MARK: - Sprite Node Lifecycle
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        addChilds()
        updateLayout()
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if minusButtonNode.contains(location) {
            delegate?.minusButtonWasPressed(self)
        } else if plusButtonNode.contains(location) { delegate?.plusButtonWasPressed(self) }
    }
    
    // MARK: - Private Methods
    
    private func addChilds() {
        addChild(minusButtonNode)
        minusButtonNode.addChild(minusButtonBackground)
        minusButtonNode.addChild(minusLabel)
        addChild(plusButtonNode)
        plusButtonNode.addChild(plusButtonBackground)
        plusButtonNode.addChild(plusLabel)
        addChild(valueNode)
        valueNode.addChild(valueBackground)
        valueNode.addChild(valueLabel)
    }
    
    private func updateLayout() {
        minusButtonNode.position = CGPoint(x: -frame.width / 2 + minusButtonNode.frame.width / 2, y: 0)
        plusButtonNode.position = CGPoint(x: frame.width / 2 - minusButtonNode.frame.width / 2, y: 0)
        minusLabel.adjustLabelFontSizeToFitRect(rectOf: minusButtonNode.size, multiplier: 0.4)
        plusLabel.adjustLabelFontSizeToFitRect(rectOf: plusButtonNode.size, multiplier: 0.4)
        valueLabel.adjustLabelFontSizeToFitRect(rectOf: valueNode.size, multiplier: 0.65)
        plusLabel.position = CGPoint(x: 0, y: -plusLabel.frame.height / 2)
        minusLabel.position = CGPoint(x: 0, y: -minusLabel.frame.height / 2)
        valueLabel.position = CGPoint(x: 0, y: -valueLabel.frame.height / 2)
    }
    
    private func setupNode() {
        isUserInteractionEnabled = true
    }
}

protocol StepperNodeDelegate: AnyObject {
    
    func minusButtonWasPressed(_ stepper: StepperNode)
    func plusButtonWasPressed(_ stepper: StepperNode)
    
}
