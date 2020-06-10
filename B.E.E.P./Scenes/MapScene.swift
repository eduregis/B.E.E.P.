//
//  MapScene.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 09/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class MapScene:SKScene {
    
    override func didMove(to view: SKView) {
        drawBackground()
        drawnTileset()
//        self.playButton = self.childNode(withName: "//starButton") as? SKSpriteNode
    }
    
    func drawBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }
    
    func drawnTileset() {
        let stage = SKSpriteNode(imageNamed: "stage-available")
        
        stage.name = "stage-1"
        stage.position = CGPoint(x: frame.midX, y: frame.midY)
        stage.zPosition = 3
        
        addChild(stage)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let stageNodeOptional = self.childNode(withName: "stage-1")
            
            if let stageNode = stageNodeOptional {
                if nodes.contains(stageNode) {
                    let gameScene = GameScene(size: view!.bounds.size)
                    view!.presentScene(gameScene)
                }
            }
        }
        
    }
    
}

