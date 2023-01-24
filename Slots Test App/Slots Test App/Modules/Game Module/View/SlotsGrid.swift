import SpriteKit

final class SlotsGrid: SKSpriteNode {
    
    // MARK: - Injections
    
    weak var delegate: SlotsGridDelegate!
    
    // MARK: - Private Methods

    private var spacing: CGFloat
    private var generalStack = SKVStack(sprites: [])
    private var sprites: [SKSpriteNode] = []
    private var lastAction: SKAction?
    
    // MARK: - Sprite Node Lifecycle
    
    init(size: CGSize, spacing: CGFloat = 24) {
        self.spacing = spacing
        super.init(texture: nil, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func reloadGrid() {
        let nodeWidth = (size.width - spacing * CGFloat(delegate.numberOfColumns(self) - 1)) / CGFloat(delegate.numberOfColumns(self))
        let nodeHeight = (size.height - spacing * CGFloat(delegate.numberOfRows(self) - 1)) / CGFloat(delegate.numberOfRows(self))
        let nodeSize = CGSize(width: nodeWidth, height: nodeHeight)
        var generalStackSprites: [SKHStack] = []
        for row in 0..<delegate.numberOfRows(self) {
            var sprites = [SKSpriteNode]()
            for column in 0..<delegate.numberOfColumns(self) {
                let texture = SKTexture(imageNamed: delegate.imageNameForCell(at: IndexPath(row: row, section: column)))
                sprites.append(SKSpriteNode(texture: texture, color: .clear, size: texture.getAdjustedTextureSize(rect: nodeSize)))
            }
            generalStackSprites.append(SKHStack(sprites: sprites, spacing: spacing))
        }
        generalStack = SKVStack(sprites: generalStackSprites, spacing: spacing)
        removeAllChildren()
        addChild(generalStack)
    }
    
}

protocol SlotsGridDelegate: AnyObject {
    
    func numberOfRows(_ slotsGrid: SlotsGrid) -> Int
    func numberOfColumns(_ slotsGrid: SlotsGrid) -> Int
    func imageNameForCell(at index: IndexPath) -> String
    
}
