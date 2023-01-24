import SpriteKit

class SKVStack: SKSpriteNode {
    
    // MARK: - Internal Properties
    
    let sprites: [SKSpriteNode]
    
    // MARK: - Sprite Node Lifecycle
    
    init(sprites: [SKSpriteNode], spacing: CGFloat = 0, position: CGPoint = .zero, alignment: SKHorizontalAlignment = .center) {
        self.sprites = sprites
        
        var width: CGFloat = 0
        var height: CGFloat = spacing * CGFloat(sprites.count - 1)
        for sprite in sprites {
            width = max(width, sprite.size.width)
            height += sprite.size.height
        }
        
        let stackSize = CGSize(width: width, height: height)
        super.init(texture: nil, color: .clear, size: stackSize)
        self.position = position
        
        var yValue = -frame.height / 2
        var xValue: CGFloat
        
        for index in 0..<sprites.count {
            switch alignment {
            case .leading:
                xValue = -(frame.width - sprites[index].size.width) / 2
            case .center:
                xValue = .zero
            case .trailing:
                xValue = (frame.width - sprites[index].size.width) / 2
            }
            yValue += sprites[index].size.height / 2
            sprites[index].position = CGPoint(x: xValue, y: yValue)
            yValue += (sprites[index].size.height / 2) + spacing
            addChild(sprites[index])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum SKHorizontalAlignment {
    case leading, center, trailing
}
