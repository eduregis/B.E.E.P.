import SpriteKit
import GameplayKit

// Cria a entidade Tileset, herdando de GKEntity
class DraggableBlock: GKEntity {

    init(name: String) {
    super.init()

    // Utiliza o componente SpriteComponent para gerar o sprite da entidade
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "\(name)"), name: name)
        
    addComponent(spriteComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
