//
//  TouchesMovedGameSceneExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 23/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if draggingItem != nil {
            for touch in touches {
                let location = touch.location(in: self)
                draggingItem?.position.x = location.x
                draggingItem?.position.y = location.y
                // detecta a dropzone da aba de comandos
                if(commandBlocks.count < 6) {
                    if (location.y > gameplayAnchor.y - 143) && (location.y < gameplayAnchor.y - 93) && (location.x > gameplayAnchor.x - 200 + 50*CGFloat(commandBlocks.count)) && (location.x < gameplayAnchor.x + 120){
                        for i in 0...commandBlocks.count {
                            if let spriteComponent = emptyBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        commandDropZoneIsTouched = true
                    } else {
                        for i in 0...commandBlocks.count {
                            if let spriteComponent = emptyBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        commandDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de função
                if(functionBlocks.count < 4) && (emptyFunctionBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y + 183) && (location.y < auxiliaryAnchor.y + 233) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(functionBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...functionBlocks.count {
                            if let spriteComponent = emptyFunctionBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        functionDropZoneIsTouched = true
                    } else {
                        for i in 0...functionBlocks.count {
                            if let spriteComponent = emptyFunctionBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        functionDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de repetição
                if(loopBlocks.count < 4) && (emptyLoopBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y + 1) && (location.y < auxiliaryAnchor.y + 51) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(loopBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...loopBlocks.count {
                            if let spriteComponent = emptyLoopBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        loopDropZoneIsTouched = true
                    } else {
                        for i in 0...loopBlocks.count {
                            if let spriteComponent = emptyLoopBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        loopDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de condicional
                if(conditionalIfBlocks.count < 4) && (emptyConditionalIfBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y - 185) && (location.y < auxiliaryAnchor.y - 135) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(conditionalIfBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...conditionalIfBlocks.count {
                            if let spriteComponent = emptyConditionalIfBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        conditionalIfDropZoneIsTouched = true
                    } else {
                        for i in 0...conditionalIfBlocks.count {
                            if let spriteComponent = emptyConditionalIfBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        conditionalIfDropZoneIsTouched = false
                    }
                }
                // detecta a dropzone da aba de condicional
                if(conditionalElseBlocks.count < 4) && (emptyConditionalElseBlocks.count > 0) {
                    if (location.y > auxiliaryAnchor.y - 247) && (location.y < auxiliaryAnchor.y - 197) && (location.x > auxiliaryAnchor.x - 55 + 50*CGFloat(conditionalElseBlocks.count)) && (location.x < auxiliaryAnchor.x + 155){
                        for i in 0...conditionalElseBlocks.count {
                            if let spriteComponent = emptyConditionalElseBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.6
                            }
                        }
                        conditionalElseDropZoneIsTouched = true
                    } else {
                        for i in 0...conditionalElseBlocks.count {
                            if let spriteComponent = emptyConditionalElseBlocks[i].component(ofType: SpriteComponent.self) {
                                spriteComponent.node.alpha = 0.1
                            }
                        }
                        conditionalElseDropZoneIsTouched = false
                    }
                }
            }
        }
    }
}
