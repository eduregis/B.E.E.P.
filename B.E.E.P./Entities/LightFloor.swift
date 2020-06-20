import SpriteKit
import GameplayKit

// Cria a entidade Tileset, herdando de GKEntity
class LightFloor: GKEntity {

    override init() {
    super.init()

    // Utiliza o componente SpriteComponent para gerar o sprite da entidade
    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "light-floor"), name: "light-floor")
    addComponent(spriteComponent)
     
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
