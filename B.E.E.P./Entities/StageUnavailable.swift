//
//  StageUnavailable.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 11/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class StageUnavailable:GKEntity {
    
    override init() {
        super.init()
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: "stage-unavailable"), name: "stage-unavailable")
        
        addComponent(spriteComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
