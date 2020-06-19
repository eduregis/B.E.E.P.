//
//  LoopGameSceneExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 14/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import GameplayKit
import SpriteKit

extension GameScene {
    
    // MARK: Add Element
    func addElementLoop(count: Double) -> Double{
        var countMove = count
        for _ in 1...loopValue {
            for block in loopBlocks{
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    // usando o trecho "-dropped-" para separar obtermos o nome original e seu índice
                    let name = spriteComponent.node.name?.components(separatedBy: "-dropped-")
                    // com o nome original será escolhido o tipo de movimento que o robot irá fazer
                    switch name![0] {
                    case "walk-block":
                        if !moveRobot() {
                            print("nao 000")
                        }else{
                            countMove += 0.9
                        }
                    case "turn-right-block":
                        arrayMoveRobot.append(turnRobot(direction: "right"))
                        countMove += 0.6
                    case "turn-left-block":
                        arrayMoveRobot.append(turnRobot(direction: "left"))
                        countMove += 0.6
                    case "grab-block":
                        print("ei")
                        if verificationBox {
                            countMove += 0.2
                            if !putBox(countMove: countMove){
                                 print("nao deu")
                            }
                        }else{
                            if !grabBox(countMove: countMove){
                                 print("nao deu")
                            }
                        }
                        /*case "grab-block"
                         
                         case "save-block"
                         
                         */
                    default:
                        break;
                    }
                }
            }
        }
        return (countMove - count)
    }
    
    
    // MARK: Draw Loop Tabs
    func drawLoopTab() {
        // adiciona a aba de repetição
        let loopTab = DefaultObject(name: "loop-tab")
        if let spriteComponent = loopTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y + 80)
            spriteComponent.node.zPosition = ZPositionsCategories.subTab
        }
        entityManager.add(loopTab)
        
        // adiciona a aba de limpar
        let clearTab = ClearTab(name: "loop-clear-tab", spriteName: "clear-auxiliary-tab")
        if let spriteComponent = clearTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 30, y: auxiliaryAnchor.y + 150)
            spriteComponent.node.zPosition = ZPositionsCategories.clearTabButton
        }
        entityManager.add(clearTab)
        
        let loopArrowLeft = DefaultObject(name: "loop-arrow-left", spriteName: "arrow-left")
        if let spriteComponent = loopArrowLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 34, y: auxiliaryAnchor.y + 100)
            spriteComponent.node.zPosition = ZPositionsCategories.button
            spriteComponent.node.alpha = 0.3
        }
        entityManager.add(loopArrowLeft)
        loopArrows.append(loopArrowLeft)
        
        loopText = SKLabelNode(text: "\(loopValue)x")
        loopText.fontName = "8bitoperator"
        loopText.fontSize = 30.0
        loopText.fontColor = .textRoyal
        loopText.zPosition = ZPositionsCategories.button
        loopText.position = CGPoint(x: auxiliaryAnchor.x + 54, y: auxiliaryAnchor.y + 87)
        addChild(loopText)
        
        let loopArrowRight = DefaultObject(name: "loop-arrow-right", spriteName: "arrow-right")
        if let spriteComponent = loopArrowRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 143, y: auxiliaryAnchor.y + 100)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(loopArrowRight)
        loopArrows.append(loopArrowRight)
        
        // container de drop
        let loopTabDropZone = DefaultObject(name: "auxiliary-tab-drop-zone")
        if let spriteComponent = loopTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 50, y: auxiliaryAnchor.y + 30)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(loopTabDropZone)
        
        // drop zones individuais
        for i in 1...4 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(i - 1)*50, y: auxiliaryAnchor.y + 30)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyLoopBlocks.append(block)
            entityManager.add(block)
        }
        
        let block = DraggableBlock(name: "loop-block")
        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 127, y: auxiliaryAnchor.y + 100)
            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
            spriteComponent.node.size = CGSize(width: 60, height: 50)
        }
        entityManager.add(block)
    }
    
}
