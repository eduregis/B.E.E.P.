//
//  FunctionGameSceneExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 23/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    // MARK: Add Element
    func addElementFunc(){
        for block in functionBlocks{
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                // usando o trecho "-dropped-" para separar obtermos o nome original e seu índice
                let name = spriteComponent.node.name?.components(separatedBy: "-dropped-")
                // com o nome original será escolhido o tipo de movimento que o robot irá fazer
                switch name![0] {
                case "walk-block":
                    if !moveRobot() {
                        print("nao deu")
                    }
                case "turn-right-block":
                    turnRobot(direction: "right")
                case "turn-left-block":
                    turnRobot(direction: "left")
                case "grab-block":
                    if verificationBox {
                        if !putBox(){
                             print("nao deu")
                        }
                    }else{
                        if !grabBox(){
                             print("nao deu")
                        }
                    }
                case "save-block":
                    if !save(){
                        print("nao deu")
                    }
                default:
                    break;
                }
            }
        }
    }
    
    // MARK: Draw Function Tabs
    func drawFunctionTab() {
        // adiciona a aba de função
        let functionTab = DefaultObject(name: "function-tab")
        if let spriteComponent = functionTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y + 225)
            spriteComponent.node.zPosition = ZPositionsCategories.subTab
        }
        entityManager.add(functionTab)
        
        // adiciona a aba de limpar
        let clearTab = ClearTab(name: "function-clear-tab", spriteName: "clear-auxiliary-tab")
        if let spriteComponent = clearTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 10, y: auxiliaryAnchor.y + 260)
            spriteComponent.node.zPosition = ZPositionsCategories.clearTabButton
        }
        entityManager.add(clearTab)
        
        // container de drop
        let functionTabDropZone = DefaultObject(name: "auxiliary-tab-drop-zone")
        if let spriteComponent = functionTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 50, y: auxiliaryAnchor.y + 210)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(functionTabDropZone)
        
        // drop zones individuais
        for i in 1...4 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(i - 1)*50, y: auxiliaryAnchor.y + 210)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyFunctionBlocks.append(block)
            entityManager.add(block)
        }
        
        let block = DraggableBlock(name: "function-block")
        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 127, y: auxiliaryAnchor.y + 210)
            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
            spriteComponent.node.size = CGSize(width: 60, height: 50)
        }
        entityManager.add(block)
    }
}
