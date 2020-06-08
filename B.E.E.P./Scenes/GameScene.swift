import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // variáveis que irão receber os valores da API
    var actualPosition = CGPoint(x: 1, y: 1)
    var stageDimensions = CGSize(width: 5, height: 6)
    var gameplayAnchor: CGPoint!
    var actualDirection = "right"
    
    // criamos a referência o gerenciador de entidades
    var entityManager: EntityManager!
    
    // instanciamos esse aqui fora porque precisamos deles depois que são desenhados
    let robot = Robot()
    let lightFloor = LightFloor()
    var emptyBlocks: [EmptyBlock] = []
    var commandBlocks: [DroppedBlock] = []
    
    // variáveis de controle
    var selectedItem: SKSpriteNode? {
        didSet {
            if let selectedPlayer = self.selectedItem {
                draggingItem = SKSpriteNode(imageNamed: "\(selectedPlayer.name ?? "")")
                draggingItem?.name = selectedPlayer.name
                draggingItem?.position = CGPoint(x: selectedPlayer.position.x, y: selectedPlayer.position.y)
                draggingItem?.size = CGSize(width: selectedPlayer.size.width * 1.5, height: selectedPlayer.size.height * 1.5)
                draggingItem?.zPosition = 20
                draggingItem?.alpha = 0.5
                addChild(draggingItem!)
            }
        }
    }
    var draggingItem: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        gameplayAnchor = CGPoint(x: size.width/2, y: size.height/2)
        
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
                    let x = gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j)
                }
                entityManager.add(tileset)
                
                // desenha a luz do tileset
                let light = Light(xPosition: i, yPosition: j, maxX: width, maxY: height)
                if let spriteComponent = light.component(ofType: SpriteComponent.self) {
                    let x = gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
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
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
            let y = gameplayAnchor.y + 200 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = CGFloat(actualPosition.x + actualPosition.y + 1)
            spriteComponent.node.alpha = 0.7
        }
        entityManager.add(lightFloor)
        
        // desenha o robô
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
            let y = gameplayAnchor.y + 236 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
        }
        entityManager.add(robot)
    }
    
    func drawTabs () {
        // adiciona a aba de comandos
        let commandTab = CommandTab()
        if let spriteComponent = commandTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x, y: gameplayAnchor.y - 100)
            spriteComponent.node.zPosition = 1
        }
        entityManager.add(commandTab)
        
        // container de drop
        let commandTabDropZone = CommandTabDropZone()
        if let spriteComponent = commandTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 40, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = 2
        }
        entityManager.add(commandTabDropZone)
        
        // drop zones individuais
        for i in 1...6 {
            let block = EmptyBlock(name: "white-block-command-\(i)")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 172 + CGFloat(i - 1)*53, y: gameplayAnchor.y - 115)
                spriteComponent.node.zPosition = 15
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            entityManager.add(block)
            print(i)
        }
        
        // botão de play
        let playButton = PlayButton()
        if let spriteComponent = playButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x + 170, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = 3
        }
        entityManager.add(playButton)
        
        // adiciona a aba de ações
        let actionTab = ActionTab()
        if let spriteComponent = actionTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x, y: gameplayAnchor.y - 240)
            spriteComponent.node.zPosition = 1
        }
        entityManager.add(actionTab)
        
        // adiciona os blocos de ações
        for i in 1...blockTypes.count {
            let block = DraggableBlock(name: blockTypes[i - 1])
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 150 + CGFloat(i - 1)*75, y: gameplayAnchor.y - 255)
                spriteComponent.node.zPosition = 20
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            entityManager.add(block)
            print(i)
        }
    }
    
    func turnRobot(direction: String) {
        // checa para qual lado o robô irá girar
        switch direction {
        case "left":
            // gira de acordo com a direção do robô
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
        // checa se o robô pode andar para a posição apontada
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
        
        // move o robô caso ele possa, fazendo a sua animação também
        if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.move(direction: actualDirection)
        }
        
        // move o bloco luminoso embaixo do robô, quando ele termina o movimento
        if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
            lightFloorMoveComponent.move(direction: actualDirection)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // moveRobot()
        // turnRobot(direction: "left")
        if let location = touches.first?.location(in: self) {
            // Checamos o nome do SpriteNode que foi detectado pela função
            if (self.atPoint(location).name == "walk-block") || (self.atPoint(location).name == "turn-left-block") || (self.atPoint(location).name == "turn-right-block") || (self.atPoint(location).name == "grab-block") || (self.atPoint(location).name == "save-block") {
                // passamos o objeto detectado para dentro do selectedItem
                selectedItem = self.atPoint(location) as? SKSpriteNode
            } else {
                // caso não seja o objeto que queremos, esvaziamos o selectedItem
                selectedItem = nil
                if (self.atPoint(location).name == "play-button") {
                   // moveRobot()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if draggingItem != nil {
            for touch in touches {
                let location = touch.location(in: self)
                draggingItem?.position.x = location.x
                draggingItem?.position.y = location.y
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingItem?.removeFromParent()
        if let location = touches.first?.location(in: self) {
            if ((self.atPoint(location).name?.starts(with: "white-block-command-")) != nil) {
                if let draggingItem = draggingItem {
                    if commandBlocks.count < 6 {
                        let block = DroppedBlock(name: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 172 + CGFloat(commandBlocks.count)*53, y: gameplayAnchor.y - 115)
                            spriteComponent.node.zPosition = 20
                        }
                        commandBlocks.append(block)
                        entityManager.add(block)
                    }
                }
            }
            draggingItem = nil
        }
    }
}
