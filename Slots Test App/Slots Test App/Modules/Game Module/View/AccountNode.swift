import SpriteKit

final class AccountNode: SKSpriteNode {
    
    // MARK: - Instance Properties
    
    var accountLabelText = "0" {
        didSet {
            accountLabel.text = accountLabelText
            updateLayout()
        }
    }
    
    // MARK: - UI
    
    private lazy var chestImage = SKSpriteNode(texture: SKTexture(imageNamed: "chest-image-big"), color: .clear, size: CGSize(width: frame.height * 1.18, height: frame.height))
    
    private lazy var accountLabelBackground = SKSpriteNode().then {
        let size = CGSize(width: frame.width, height: frame.height * 0.3)
        $0.size = size
        let gradientColors = [UIColor(hexString: "#F3A64E")!.cgColor, UIColor(hexString: "#ED783F")!.cgColor]
        let gradientImage = UIImage.gradientImage(withBounds: CGRect(origin: .zero, size: size), colors: [UIColor(hexString: "#F3A64E")!.cgColor, UIColor(hexString: "##ED783F")!.cgColor])
        $0.texture = SKTexture(image: gradientImage)
    }
    
    private var accountLabel = SKLabelNode(text: "0").then {
        $0.fontName = Constants.Design.FontName.robotoBold
        $0.fontColor = UIColor(hexString: "#2B2836")!
    }
    
    // MARK: - Sprite Node Lifecycle
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        addChilds()
        updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func addChilds() {
        addChild(chestImage)
        addChild(accountLabelBackground)
        addChild(accountLabel)
    }
    
    private func updateLayout() {
        accountLabelBackground.position = CGPoint(x: 0, y: -frame.height / 2 + accountLabelBackground.size.height / 2)
        accountLabel.adjustLabelFontSizeToFitRect(rectOf: accountLabelBackground.size, multiplier: 0.7)
        accountLabel.position = CGPoint(x: 0, y: accountLabelBackground.position.y - accountLabel.frame.height / 2)
    }
    
}
