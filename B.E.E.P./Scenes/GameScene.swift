import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var actualPosition = CGPoint(x: 1, y: 1)
    var stageDimensions = CGSize(width: 5, height: 6)
    var actualDirection = "right"
    // criamos a referência o gerenciador de entidades
    var entityManager: EntityManager!
    
    let robot = Robot()
    let lightFloor = LightFloor()
    
    override func didMove(to view: SKView) {
        
        // adiciona o background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)
        
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)
        
        drawTilesets(width: Int(stageDimensions.width), height: Int(stageDimensions.height))
        drawRobot(xPosition: Int(actualPosition.x), yPosition: Int(actualPosition.y))
        drawTabs()
    }
    
    // desenha o tileset e seu corredor de luz de acordo com sua posição
    func drawTilesets(width: Int, height: Int) {
        for i in 1...width {
            for j in 1...height {
                
                // desenha o tileset
                let tileset = Tileset()
                if let spriteComponent = tileset.component(ofType: SpriteComponent.self) {
                    let x = size.width/2 + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = size.height/2 + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j)
                }
                entityManager.add(tileset)
                
                // desenha a luz do tileset
                let light = Light(xPosition: i, yPosition: j, maxX: width, maxY: height)
                if let spriteComponent = light.component(ofType: SpriteComponent.self) {
                    let x = size.width/2 + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = size.height/2 + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j + 2)
                }
                entityManager.add(light)
            }
        }
    }
    
    func drawRobot (xPosition: Int, yPosition: Int) {
        // desenha o chão iluminado embaixo do robô
        if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
            let x = size.width/2 + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
            let y = size.height/2 + 200 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = CGFloat(actualPosition.x + actualPosition.y + 1)
            spriteComponent.node.alpha = 0.7
        }
        entityManager.add(lightFloor)
        
        // desenha o robô
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            let x = size.width/2 + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
            let y = size.height/2 + 236 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
        }
        entityManager.add(robot)
    }
    
    func drawTabs () {
        
    }
    
    func turnRobot(direction: String) {
        switch direction {
        case "left":
            switch actualDirection {
            case "up":
                actualDirection = "left"
            case "left":
                actualDirection = "down"
            case "down":
                actualDirection = "right"
            case "right":
                actualDirection = "up"
            default:
                break
            }
        case "right":
            switch actualDirection {
            case "up":
                actualDirection = "right"
            case "left":
                actualDirection = "up"
            case "down":
                actualDirection = "left"
            case "right":
                actualDirection = "down"
            default:
                break
            }
        default:
            break
        }
        if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.turn(direction: actualDirection)
        }
    }
    
    func moveRobot() -> Bool {
        print("asasd")
        switch actualDirection {
        case "up":
            if (actualPosition.y == 1) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
            }
        case "left":
            if (actualPosition.x == 1) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
            }
        case "down":
            if (actualPosition.y == stageDimensions.height) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
            }
        case "right":
            if (actualPosition.x == stageDimensions.width) {
                return false
            } else {
                actualPosition = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
            }
        default:
            actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y)
        }
        
        if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.move(direction: actualDirection)
        }
        
        if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
            lightFloorMoveComponent.move(direction: actualDirection)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnRobot(direction: "left")
    }
}
