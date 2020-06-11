//
//  ReturnButton.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 09/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class HubButton:GKEntity {
    
    init(name: String) {
          super.init()

          // Utiliza o componente SpriteComponent para gerar o sprite da entidade
          let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: name), name: name)
          
          addComponent(spriteComponent)
      }
    
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
