import SpriteKit
import GameplayKit

// Cria a entidade Tileset, herdando de GKEntity
class DroppedBlock: GKEntity {
    var actionName: String!
    
    init(name: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "\(name)"), name: name)
        actionName = name
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
