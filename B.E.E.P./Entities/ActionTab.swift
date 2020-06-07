import SpriteKit
import GameplayKit

// Cria a entidade ActionTab, herdando de GKEntity
class ActionTab: GKEntity {

    override init() {
    super.init()

    // Utiliza o componente SpriteComponent para gerar o sprite da entidade
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "action-tab"), name: "action-tab")
        
    addComponent(spriteComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
