//
//  Filament.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 10/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class Filament:GKEntity {
    
    init(status:String) {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "filament-\(status)"), name: "filament")
        
        addComponent(spriteComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
