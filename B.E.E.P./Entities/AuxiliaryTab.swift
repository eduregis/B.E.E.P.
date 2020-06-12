import SpriteKit
import GameplayKit

// Cria a entidade ActionTab, herdando de GKEntity
class AuxiliaryTab: GKEntity {

    init(size: Int) {
    super.init()

    // Utiliza o componente SpriteComponent para gerar o sprite da entidade
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "aux-tab-\(size)"), name: "aux-tab-\(size)")
        
    addComponent(spriteComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
