import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // criamos a referência o gerenciador de entidades
    var entityManager: EntityManager!
    override func didMove(to view: SKView) {
        
        // adiciona o background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)
        
        // cria uma instância do gerenciador de entidades
        entityManager = EntityManager(scene: self)
        
        drawTilesets(width: 5, height: 5)
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
                    spriteComponent.node.zPosition = CGFloat(i + j + 1)
                }
                entityManager.add(light)
            }
        }
    }
}
