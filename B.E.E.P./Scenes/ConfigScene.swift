
import SpriteKit
import GameplayKit

class ConfigScene:SKScene {
    
    lazy var backName:String = {return self.userData?["backSaved"] as? String ?? "configScene"}()
    
   
    var posicao:Int = 0
    var locationAnterior:CGPoint = CGPoint(x: 0, y: 0)
    
    var touchesBeganLocation = CGPoint(x: 0, y: 0)
    
     // criamos a referência o gerenciador de entidades
     var entityManager: EntityManager!
    
    override func didMove(to view: SKView) {
        
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)
        drawBackground()
        drawnReturnButton()
        
 }
    
    func drawBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }

    func drawnReturnButton() {
        let returnButton = HudButton(name: "return-button")
        if let spriteComponent = returnButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(returnButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchesBeganLocation = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
 //       for touch in touches {
//            let location = touch.location(in: self)
//            if locationAnterior.x < location.x {
//                if self.posicao > 0 {
//                    moveMap(direction: Direction.backward)
//                    self.posicao -= 1
//                }
//            } else {
//                if self.posicao < 150 {
//                    moveMap(direction: Direction.forward)
//                    self.posicao += 1
//                }
//            }
//            locationAnterior = location
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            if location == touchesBeganLocation {
//                let nodes = self.nodes(at: location)
//                if nodes[0].name?.contains("stage-available") ?? false {
//                    let gameScene = GameScene(size: view!.bounds.size)
//                    view!.presentScene(gameScene)
//                }
//            }
//        }
            
        //verifica se clicou no botão voltar
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let returnButtonOptional = self.childNode(withName: "return-button")
            
            if let returnButton = returnButtonOptional {
                if nodes.contains(returnButton) {
                    switch self.backName {
                    case "mapScene":
                        let mapScene = MapScene(size: view!.bounds.size)
                        view!.presentScene(mapScene)
                    case "gameScene":
                        let gameScene = GameScene(size: view!.bounds.size)
                        view!.presentScene(gameScene)
                    default:
                        let mapScene = MapScene(size: view!.bounds.size)
                        view!.presentScene(mapScene)
                    }
                }
            }
        }
    }
    
}


