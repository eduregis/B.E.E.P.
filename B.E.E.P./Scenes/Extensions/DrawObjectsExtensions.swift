//
//  DrawObjectsExtensions.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 13/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import GameplayKit
import SpriteKit

extension GameScene {
    
    // desenha o tileset e seu corredor de luz de acordo com sua posição
    func drawTilesets(width: Int, height: Int) {
        for i in 1...width {
            for j in 1...height {
                
                // desenha o tileset
                let tileset = Tileset()
                if let spriteComponent = tileset.component(ofType: SpriteComponent.self) {
                    let x = gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j)
                }
                entityManager.add(tileset)
                
                // desenha a luz do tileset
                let light = Light(xPosition: i, yPosition: j, maxX: width, maxY: height)
                if let spriteComponent = light.component(ofType: SpriteComponent.self) {
                    let x = gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j + 2)
                }
                entityManager.add(light)
            }
        }
    }
    
    func drawRobot (xPosition: Int, yPosition: Int) {
        // desenha o chão iluminado embaixo do robô
        if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition)) - CGFloat(32 * (yPosition))
            let y = gameplayAnchor.y + 200 - CGFloat(16 * (xPosition)) - CGFloat(16 * (yPosition))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = CGFloat(xPosition + yPosition) + 3
            print(CGFloat(xPosition + yPosition) + 3)
            spriteComponent.node.alpha = 0.6
        }
        entityManager.add(lightFloor)
        
        // desenha o robô
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition)) - CGFloat(32 * (yPosition))
            let y = gameplayAnchor.y + 236 - CGFloat(16 * (xPosition)) - CGFloat(16 * (yPosition))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
        }
        entityManager.add(robot)
    }
    
    func drawTabs () {
        // adiciona a aba de comandos
        let commandTab = DefaultObject(name: "command-tab")
        if let spriteComponent = commandTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x, y: gameplayAnchor.y - 100)
            spriteComponent.node.zPosition = ZPositionsCategories.tab
        }
        entityManager.add(commandTab)
        
        // adiciona a aba de limpar
        let clearTab = ClearTab(name: "command-clear-tab", spriteName: "clear-tab")
        if let spriteComponent = clearTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 20, y: gameplayAnchor.y - 65)
            spriteComponent.node.zPosition = ZPositionsCategories.clearTabButton
        }
        entityManager.add(clearTab)
        
        // container de drop
        let commandTabDropZone = DefaultObject(name: "command-tab-drop-zone")
        if let spriteComponent = commandTabDropZone.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 50, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = ZPositionsCategories.dropZone
        }
        entityManager.add(commandTabDropZone)
        
        // drop zones individuais
        for i in 1...6 {
            let block = EmptyBlock(name: "white-block")
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 175 + CGFloat(i - 1)*50, y: gameplayAnchor.y - 115)
                spriteComponent.node.zPosition = ZPositionsCategories.emptyBlock
                spriteComponent.node.alpha = 0.1
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            emptyBlocks.append(block)
            entityManager.add(block)
        }
        
        // botão de play
        let playButton = DefaultObject(name: "play-button")
        if let spriteComponent = playButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x + 170, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(playButton)
        
        // botão de stop
        if let spriteComponent = stopButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x + 170, y: gameplayAnchor.y - 115)
            spriteComponent.node.zPosition = 0
        }
        entityManager.add(stopButton)
        
        // adiciona a aba de ações
        let actionTab = DefaultObject(name: "action-tab")
        if let spriteComponent = actionTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: gameplayAnchor.x, y: gameplayAnchor.y - 240)
            spriteComponent.node.zPosition = ZPositionsCategories.tab
        }
        entityManager.add(actionTab)
        
        // adiciona os blocos de ações
        for i in 1...blockTypes.count {
            let block = DraggableBlock(name: blockTypes[i - 1])
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 150 + CGFloat(i - 1)*75, y: gameplayAnchor.y - 255)
                spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            entityManager.add(block)
        }
    }
    
    func drawAuxiliaryTab() {
        let size: Int
        let yAjust: CGFloat
        if tabStyle != "default" {
            switch tabStyle {
            case "function","antivirus":
                size = 1
                yAjust = 240
            case "loop":
                size = 2
                yAjust = 148
            default:
                size = 3
                yAjust = 28
            }
            let auxiliaryTab = AuxiliaryTab(size: size)
            if let spriteComponent = auxiliaryTab.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y + yAjust)
                spriteComponent.node.zPosition = ZPositionsCategories.tab
            }
            
            entityManager.add(auxiliaryTab)
            drawFunctionTab()
            
            if(tabStyle == "loop") || (tabStyle == "conditional") {
                drawLoopTab()
            }
            
            if(tabStyle == "conditional") {
               drawConditionalTab()
            }
        }
    }
    
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
        loopText.fontColor = .magenta
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
        
        conditionalText = SKLabelNode(text: "\(conditionalValue)x")
        conditionalText.fontName = "8bitoperator"
        conditionalText.fontSize = 30.0
        conditionalText.fontColor = .magenta
        conditionalText.zPosition = ZPositionsCategories.button
        conditionalText.position = CGPoint(x: auxiliaryAnchor.x + 54, y: auxiliaryAnchor.y - 94)
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
    
    func clearTab (tabName: String) {
        switch tabName {
        case "command":
            for block in commandBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            commandBlocks.removeAll()
            resetMoveRobot()
        case "function":
            for block in functionBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            functionBlocks.removeAll()
        case "loop":
            for block in loopBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            loopBlocks.removeAll()
        case "conditional":
        for block in conditionalIfBlocks {
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.removeFromParent()
            }
        }
        for block in conditionalElseBlocks {
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.removeFromParent()
            }
        }
        conditionalIfBlocks.removeAll()
        conditionalElseBlocks.removeAll()
        default:
            break
        }
    }
    
    func drawnReturnButton() {
        let returnButton = HubButton(name: "return-button")
        if let spriteComponent = returnButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(returnButton)
    }
    func drawnConfigButton() {
        let configButton = HubButton(name: "config-button")
        if let spriteComponent = configButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(configButton)
    }
    func drawnHintButton() {
        let hintButton = HubButton(name: "hint-button")
        if let spriteComponent = hintButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(hintButton)
    }
    
    func drawBoxes () {
        for i in 0..<boxes.count {
            let box = DefaultObject(name: "box (\(boxes[i].x) - \(boxes[i].y)", spriteName: "box")
            if let spriteComponent = box.component(ofType: SpriteComponent.self) {
                let x = gameplayAnchor.x + CGFloat(32 * (boxes[i].x - 1)) - CGFloat(32 * (boxes[i].y - 1))
                let y = gameplayAnchor.y + 182 - CGFloat(16 * (boxes[i].x - 1)) - CGFloat(16 * (boxes[i].y - 1))
                spriteComponent.node.position = CGPoint(x: x, y: y)
                spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(boxes[i].x + boxes[i].y) + 1
            }
            entityManager.add(box)
        }
    }
    
    func drawBoxDropZones () {
        for i in 0..<boxDropZones.count {
            let boxDropZone = DefaultObject(name: "box-drop-zone (\(boxDropZones[i].x) - \(boxDropZones[i].y)", spriteName: "box-empty-floor")
            if let spriteComponent = boxDropZone.component(ofType: SpriteComponent.self) {
                let x = gameplayAnchor.x + CGFloat(32 * (boxDropZones[i].x - 1)) - CGFloat(32 * (boxDropZones[i].y - 1))
                let y = gameplayAnchor.y + 168 - CGFloat(16 * (boxDropZones[i].x - 1)) - CGFloat(16 * (boxDropZones[i].y - 1))
                spriteComponent.node.position = CGPoint(x: x, y: y)
                spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(boxDropZones[i].x + boxDropZones[i].y) + 1
            }
            entityManager.add(boxDropZone)
        }
    }
    
    func updateLoopText () {
        loopText.text = "\(loopValue)x"
    }
    
    func updateConditionalText () {
        conditionalText.text = "\(conditionalValue)x"
    }
}
