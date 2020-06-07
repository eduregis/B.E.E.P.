import SpriteKit
import GameplayKit

// Cria a entidade CommandTab, herdando de GKEntity
class CommandTab: GKEntity {

    override init() {
    super.init()

    // Utiliza o componente SpriteComponent para gerar o sprite da entidade
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "command-tab"), name: "command-tab")
        
    addComponent(spriteComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
