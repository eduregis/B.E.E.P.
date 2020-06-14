//
//  ConditionalGameSceneExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 14/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import GameplayKit
import SpriteKit

extension GameScene {
    
    // MARK: Add Element
    
    func addElementConditional(){
        var conditionalBlocks: [DraggableBlock] = []
        switch conditionalValue {
        case 0:
            if objectAhead(type: "infected") {
                conditionalBlocks = conditionalIfBlocks
            } else {
                conditionalBlocks = conditionalElseBlocks
            }
        case 1:
            if objectAhead(type: "box") {
                conditionalBlocks = conditionalIfBlocks
            } else {
                conditionalBlocks = conditionalElseBlocks
            }
        case 2:
            if cliffAhead() {
                conditionalBlocks = conditionalIfBlocks
            } else {
                conditionalBlocks = conditionalElseBlocks
            }
        case 3:
            if objectAhead(type: "dropZone") {
                conditionalBlocks = conditionalIfBlocks
            } else {
                conditionalBlocks = conditionalElseBlocks
            }
        default:
            break
        }
        for block in conditionalBlocks{
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
                    arrayMoveRobot.append(turnRobot(direction: "right"))
                case "turn-left-block":
                    arrayMoveRobot.append(turnRobot(direction: "left"))
                    /*case "grab-block"
                     
                     case "save-block"
                     
                     */
                default:
                    break;
                }
            }
        }
    }
    
    // MARK: Conditions
    
    func objectAhead(type: String) -> Bool {
        
        var objectArray: [CGPoint] = []
        
        switch type {
        case "infected":
            objectArray = infectedRobots
        case "dropZone":
            objectArray = boxDropZones
        case "box":
            objectArray = boxes
        default:
            return false
        }
        
        switch actualDirection {
        case "up":
            if(actualPosition.y == 0) {
                return false
            } else {
                if objectArray.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) {
                    return true
                } else {
                    return false
                }
            }
        case "left":
            if(actualPosition.x == 0) {
                return false
            } else {
                if objectArray.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) {
                    return true
                } else {
                    return false
                }
            }
        case "down":
            if(actualPosition.y == stageDimensions.height - 1) {
                return false
            } else {
                if objectArray.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) {
                    return true
                } else {
                    return false
                }
            }
        case "right":
            if(actualPosition.y == stageDimensions.width - 1) {
                return false
            } else {
                if objectArray.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) {
                    return true
                } else {
                    return false
                }
            }
        default:
            return false
        }
    }
    
    func cliffAhead() -> Bool {
        switch actualDirection {
        case "up":
            if(actualPosition.y == 0) {
                return true
            }
        case "left":
            if(actualPosition.x == 0) {
                return true
            }
        case "down":
            if(actualPosition.y == stageDimensions.height - 1) {
                return true
            }
        case "right":
            if(actualPosition.y == stageDimensions.width - 1) {
                return true
            }
        default:
            return true
        }
        return false
    }
    
    // MARK: Draw
    
    func drawConditionalTab() {
        // adiciona a aba de comandos
        let conditionalTab = DefaultObject(name: "conditional-tab")
        if let spriteComponent = conditionalTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y - 133)
            spriteComponent.node.zPosition = ZPositionsCategories.subTab
        }
        entityManager.add(conditionalTab)
        
        // adiciona a aba de limpar
        let clearTab = ClearTab(name: "conditional-clear-tab", spriteName: "clear-auxiliary-tab")
        if let spriteComponent = clearTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 50, y: auxiliaryAnchor.y - 31)
            spriteComponent.node.zPosition = ZPositionsCategories.clearTabButton
        }
        entityManager.add(clearTab)
        
        let conditionalArrowLeft = DefaultObject(name: "conditional-arrow-left", spriteName: "arrow-left")
        if let spriteComponent = conditionalArrowLeft.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 34, y: auxiliaryAnchor.y - 81)
            spriteComponent.node.zPosition = ZPositionsCategories.button
            spriteComponent.node.alpha = 0.3
        }
        entityManager.add(conditionalArrowLeft)
        conditionalArrows.append(conditionalArrowLeft)
        
        conditionalText = SKLabelNode(text: conditions[conditionalValue])
        conditionalText.fontName = "8bitoperator"
        conditionalText.fontSize = 14.0
        conditionalText.fontColor = .magenta
        conditionalText.zPosition = ZPositionsCategories.button
        conditionalText.position = CGPoint(x: auxiliaryAnchor.x + 54, y: auxiliaryAnchor.y - 103)
        conditionalText.numberOfLines = 2
        addChild(conditionalText)
        
        let conditionalArrowRight = DefaultObject(name: "conditional-arrow-right", spriteName: "arrow-right")
        if let spriteComponent = conditionalArrowRight.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 143, y: auxiliaryAnchor.y - 81)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(conditionalArrowRight)
        conditionalArrows.append(conditionalArrowRight)
        
        // container de drop
        let conditionalTabDropZone = DefaultObject(name: "auxiliary-tab-drop-zone")
        if let spriteComponent = conditionalTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 50, y: auxiliaryAnchor.y - 151)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(conditionalTabDropZone)
        
        // drop zones individuais
        for i in 1...4 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(i - 1)*50, y: auxiliaryAnchor.y - 151)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyConditionalIfBlocks.append(block)
            entityManager.add(block)
        }
        
        let block = DraggableBlock(name: "conditional-block")
        if let spriteComponent = block.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 127, y: auxiliaryAnchor.y - 81)
            spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
            spriteComponent.node.size = CGSize(width: 60, height: 50)
        }
        entityManager.add(block)
        
        // container de drop
        let conditionalElseTabDropZone = DefaultObject(name: "auxiliary-tab-drop-zone")
        if let spriteComponent = conditionalElseTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x + 50, y: auxiliaryAnchor.y - 213)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(conditionalElseTabDropZone)
        
        // drop zones individuais
        for i in 1...4 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x - 25 + CGFloat(i - 1)*50, y: auxiliaryAnchor.y - 213)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyConditionalElseBlocks.append(block)
            entityManager.add(block)
        }
    }
}
