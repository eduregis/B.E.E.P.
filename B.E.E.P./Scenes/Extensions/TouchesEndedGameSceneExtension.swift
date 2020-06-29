//
//  TouchesEndedGameSceneExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 23/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        draggingItem?.removeFromParent()
        if let location = touches.first?.location(in: self) {
            // checa se o local onde o objeto está send solto é um boco branco, que funciona como uma dropzone
            if (self.atPoint(location).name == "white-block") {
                if let draggingItem = draggingItem {
                    // checa qual area de contato está sendo acionada, e se aquele array tem espaço
                    if (commandBlocks.count < 6) && commandDropZoneIsTouched {
                        // usamos o nome do array para identificar o bloco, além de um índice
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-command-\(commandBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            // devolve ao objeto seu tamanho e opacidade
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 175 + CGFloat(commandBlocks.count)*50, y: gameplayAnchor.y - 115)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        // adiciona o bloco no gerenciador de entidades, e também no array
                        commandBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (functionBlocks.count < 4) && functionDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-function-\(functionBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(functionBlocks.count)*50, y: auxiliaryAnchor.y + 210)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        functionBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (loopBlocks.count < 4) && loopDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-loop-\(loopBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(loopBlocks.count)*50, y: auxiliaryAnchor.y + 30)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        loopBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (conditionalIfBlocks.count < 4) && conditionalIfDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-conditional-if-\(conditionalIfBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(conditionalIfBlocks.count)*50, y: auxiliaryAnchor.y - 151)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        conditionalIfBlocks.append(block)
                        entityManager.add(block)
                    }
                    if (conditionalElseBlocks.count < 4) && conditionalElseDropZoneIsTouched && draggingItem.name != "function-block" && draggingItem.name != "loop-block" && draggingItem.name != "conditional-block" {
                        let block = DraggableBlock(name: "\(draggingItem.name ?? "")-dropped-conditional-else-\(conditionalElseBlocks.count)" , spriteName: draggingItem.name ?? "")
                        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                            spriteComponent.node.size = CGSize(width: draggingItem.size.width / 1.5, height: draggingItem.size.height / 1.5)
                            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(conditionalElseBlocks.count)*50, y: auxiliaryAnchor.y - 213)
                            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                        }
                        conditionalElseBlocks.append(block)
                        entityManager.add(block)
                    }
                }
            }
            // coloca todos os dropzones com opacidade 0.1
            for i in 0..<emptyBlocks.count {
                if let whiteBlock = emptyBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyFunctionBlocks.count {
                if let whiteBlock = emptyFunctionBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyLoopBlocks.count {
                if let whiteBlock = emptyLoopBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyConditionalIfBlocks.count {
                if let whiteBlock = emptyConditionalIfBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            for i in 0..<emptyConditionalElseBlocks.count {
                if let whiteBlock = emptyConditionalElseBlocks[i].component(ofType: SpriteComponent.self) {
                    whiteBlock.node.alpha = 0.1
                }
            }
            draggingItem = nil
        }
        //verifica se clicou no botão voltar
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            let returnButtonOptional = self.childNode(withName: "return-button")
            if let returnButton = returnButtonOptional {
                if nodes.contains(returnButton) {
                    returnToMap()
                }
            }
            if nodes[0].name?.contains("config-button") ?? false {
               let configScene = ConfigScene(size: view!.bounds.size)
               configScene.userData = configScene.userData ?? NSMutableDictionary()
               configScene.userData!["backSaved"] = backName
               view!.presentScene(configScene)
            }
        }
    }
}
