import SpriteKit
import GameplayKit

// Cria a entidade ActionTab, herdando de GKEntity
class DefaultObject: GKEntity {
    
    init(name: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "\(name)"), name: name)
        addComponent(spriteComponent)
    }
    
    init(name: String, spriteName: String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "\(spriteName)"), name: name)
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
