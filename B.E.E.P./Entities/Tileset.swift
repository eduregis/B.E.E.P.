import SpriteKit
import GameplayKit

// Cria a entidade Tileset, herdando de GKEntity
class Tileset: GKEntity {

    override init() {
        super.init()
        // Utiliza o componente SpriteComponent para gerar o sprite da entidade
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "tileset"), name: "tileset")
        
        addComponent(spriteComponent)
    }
    init(status:String){
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "tileset-\(status)"), name: "tileset")
        
        addComponent(spriteComponent)
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
