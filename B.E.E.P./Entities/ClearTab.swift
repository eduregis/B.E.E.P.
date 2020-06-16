import SpriteKit
import GameplayKit

// Cria a entidade Tileset, herdando de GKEntity
class ClearTab: GKEntity {
    var actionName: String!
    
    init(name: String, spriteName: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "\(spriteName)"), name: name)
        actionName = name
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
