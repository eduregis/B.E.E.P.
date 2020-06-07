import SpriteKit
import GameplayKit

// Cria a entidade Light, herdando de GKEntity
class Light: GKEntity {
    
    init(xPosition: Int, yPosition: Int, maxX: Int, maxY: Int) {
        super.init()
        
        let spriteComponent: SpriteComponent
        // escolhe o sprite de acordo com a posição do tileset na matriz
        switch yPosition {
        case 1:
            switch xPosition {
            case 1:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (1 - 1)"), name: "light")
            case maxX:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (1 - 3)"), name: "light")
            default:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (1 - 2)"), name: "light")
            }
        case maxY:
            switch xPosition {
            case 1:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (3 - 1)"), name: "light")
            case maxX:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (3 - 3)"), name: "light")
            default:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (3 - 2)"), name: "light")
            }
        default:
            switch xPosition {
            case 1:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (2 - 1)"), name: "light")
            case maxX:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (2 - 3)"), name: "light")
            default:
                spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light (2 - 2)"), name: "light")
            }
        }
        
        let pulsed = SKAction.sequence([
            SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.5),
            SKAction.colorize(with: .magenta, colorBlendFactor: 1.0, duration: 1.0)])
        spriteComponent.node.run(SKAction.repeatForever(pulsed))
        
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
