import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

  // 1
  var entities = Set<GKEntity>()
  let scene: SKScene

  // 2
  init(scene: SKScene) {
    self.scene = scene
  }

  // 3
  func add(_ entity: GKEntity) {
    entities.insert(entity)

    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }
  }

  // 4
  func remove(_ entity: GKEntity) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }

    entities.remove(entity)
  }
}
