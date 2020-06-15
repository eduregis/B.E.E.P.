import SpriteKit
import GameplayKit

class RobotMoveComponent: GKComponent {
    
    private var node: SKSpriteNode {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else {
            fatalError("This entity don't have node")
        }
        return node
    }
    
    override init() {
        super.init()
    }
    
    func move(direction: String) -> SKAction{
             
        let move: SKAction
        let textures: [SKTexture]
        
        switch direction {
        case "up":
            move = SKAction.move(by: CGVector(dx: 32, dy: 16), duration: 0.6)
            textures = [SKTexture(imageNamed: "robot-idle-up-1"), SKTexture(imageNamed: "robot-idle-up-2"), SKTexture(imageNamed: "robot-idle-up-3")]
        case "left":
            move = SKAction.move(by: CGVector(dx: -32, dy: 16), duration: 0.6)
            textures = [SKTexture(imageNamed: "robot-idle-left-1"), SKTexture(imageNamed: "robot-idle-left-2"), SKTexture(imageNamed: "robot-idle-left-3")]
        case "down":
                move = SKAction.move(by: CGVector(dx: -32, dy: -16), duration: 0.6)
            textures = [SKTexture(imageNamed: "robot-idle-down-1"), SKTexture(imageNamed: "robot-idle-down-2"), SKTexture(imageNamed: "robot-idle-down-3")]
        case "right":
            move = SKAction.move(by: CGVector(dx: 32, dy: -16), duration: 0.6)
            textures = [SKTexture(imageNamed: "robot-idle-right-1"), SKTexture(imageNamed: "robot-idle-right-2"), SKTexture(imageNamed: "robot-idle-right-3")]
        default:
            move = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 0.6)
            textures = []
        }
        let animate = SKAction.animate(with: textures, timePerFrame: 0.2, resize: false, restore: false)
        
         //node.run(SKAction.group([move, animate]))*/
        
        return SKAction.group([move, animate])
    }
    
    func moveComplete(move: [SKAction], button: GKEntity){
        
        let sequence = SKAction.sequence(move)
        node.run(sequence){
            if let button = button.component(ofType: SpriteComponent.self){
                button.node.zPosition = 0
            }
        }
    }
    
    func turn(direction: String) -> SKAction{
        let texture = SKTexture(imageNamed: "robot-idle-\(direction)-2")
        let textures: [SKTexture] = [texture]
        /*node.run(SKAction.wait(forDuration: 0.6)){
            self.node.texture = texture
        }*/
        let animate = SKAction.animate(with: textures, timePerFrame: 0.6, resize: false, restore: false)
        return animate
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
