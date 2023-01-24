import SpriteKit

class SKHStack: SKSpriteNode {
    
    // MARK: - Internal Properties
    
    let sprites: [SKSpriteNode]
    
    // MARK: - Sprite Node Lifecycle
    
    init(sprites: [SKSpriteNode], spacing: CGFloat = 0, position: CGPoint = .zero, alignment: SKVerticalAlignment = .center) {
        self.sprites = sprites
        
        var width: CGFloat = spacing * CGFloat(sprites.count - 1)
        var height: CGFloat = 0
        for sprite in sprites {
            width += sprite.size.width
            height = max(height, sprite.size.height)
        }
        
        let stackSize = CGSize(width: width, height: height)
        super.init(texture: nil, color: .clear, size: stackSize)
        self.position = position
        
        var yValue: CGFloat
        var xValue = -frame.width / 2
        
        for index in 0..<sprites.count {
            switch alignment {
            case .bottom:
                yValue = -(frame.height - sprites[index].size.height) / 2
            case .center:
                yValue = .zero
            case .top:
                yValue = (frame.height - sprites[index].size.height) / 2
            }
            xValue += sprites[index].size.width / 2
            sprites[index].position = CGPoint(x: xValue, y: yValue)
            xValue += (sprites[index].size.width / 2) + spacing
            addChild(sprites[index])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum SKVerticalAlignment {
    case bottom, center, top
}
