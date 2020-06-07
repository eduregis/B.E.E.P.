import SpriteKit
import GameplayKit

// Cria a entidade Robot, herdando de GKEntity
class Robot: GKEntity {
    
    override init() {
        super.init()
        
        // Utiliza o componente SpriteComponent para gerar o sprite da entidade
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "robot-idle-right-2"), size: CGSize(width: 64, height: 64), name: "robot")
        addComponent(spriteComponent)
        
        let robotMoveComponent = RobotMoveComponent()
        addComponent(robotMoveComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
