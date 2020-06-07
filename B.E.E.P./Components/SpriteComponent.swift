import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    // criamos uma variável que receberá o sprite
    let node: SKSpriteNode
    
    // criamos um construtor caso o tmanho da imagem seja o mesmo em que ele deva aparecer na tela
    init(texture: SKTexture, name: String) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        node.name = name
        super.init()
    }
    
    // criamos um contrutor que também recebe um tamanho, caso precisemos redimensionar o sprite
    init(texture: SKTexture, size: CGSize, name: String) {
        node = SKSpriteNode(texture: texture, color: .white, size: size)
        node.name = name
        super.init()
    }
    
    // construtor padrão de erro
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
