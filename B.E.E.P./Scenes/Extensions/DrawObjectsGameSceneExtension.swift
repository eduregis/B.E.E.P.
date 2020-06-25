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
    
    // MARK: Draw Tilesets
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
    
    // MARK: Draw Robots
    func drawRobot (xPosition: Int, yPosition: Int) {
        // desenha o robô
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition)) - CGFloat(32 * (yPosition))
            let y = gameplayAnchor.y + 232 - CGFloat(16 * (xPosition)) - CGFloat(16 * (yPosition))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
        }
        entityManager.add(robot)
        
        // desenha o chão iluminado embaixo do robô
       if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
           let x = gameplayAnchor.x + CGFloat(32 * (xPosition)) - CGFloat(32 * (yPosition))
           let y = gameplayAnchor.y + 200 - CGFloat(16 * (xPosition)) - CGFloat(16 * (yPosition))
           spriteComponent.node.position = CGPoint(x: x, y: y)
           //spriteComponent.node.zPosition = CGFloat(xPosition + yPosition) + 3
           if let robot = robot.component(ofType: SpriteComponent.self){
               spriteComponent.node.zPosition = (robot.node.zPosition - 0.3)
           }
           spriteComponent.node.alpha = 0.6
       }
       entityManager.add(lightFloor)
    }
    
    // MARK: Draw Robots Infected
    func drawRobotInfected (xPosition: Int, yPosition: Int) {
        // desenha o robô infectado
        print(xPosition, yPosition)
        let robotInfected = DefaultObject(name: "robotInfected", spriteName: "infected-right", size: CGSize(width: 64, height: 64))
       if let spriteComponent = robotInfected.component(ofType: SpriteComponent.self) {
            spriteComponent.node.texture = SKTexture(imageNamed: "infected-left")
            spriteComponent.node.size = CGSize(width: 64, height: 64)
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition)) - CGFloat(32 * (yPosition))
            let y = gameplayAnchor.y + 232 - CGFloat(16 * (xPosition)) - CGFloat(16 * (yPosition))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
            
       }
        let robotCured = DefaultObject(name: "robotCured", spriteName: "robot-idle-right-2", size: CGSize(width: 64, height: 64))
        if let spriteComponent = robotCured.component(ofType: SpriteComponent.self) {
            spriteComponent.node.texture = SKTexture(imageNamed: "robot-idle-left-2")
            spriteComponent.node.size = CGSize(width: 64, height: 64)
            let x = gameplayAnchor.x + CGFloat(32 * (xPosition)) - CGFloat(32 * (yPosition))
            let y = gameplayAnchor.y + 232 - CGFloat(16 * (xPosition)) - CGFloat(16 * (yPosition))
            spriteComponent.node.position = CGPoint(x: x, y: y)
            spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition)
            
        }
        entityManager.add(robotCured)
        entityManager.add(robotInfected)
        arrayInfectedRobot.append(robotInfected)
    }
    
    // MARK: Draw Tabs
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
            spriteComponent.node.zPosition = -1
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
        var blockTypesLength = blockTypes.count
        if (tabStyle == "default") || (tabStyle == "function") {
            blockTypesLength = blockTypesLength - 1
        }
        for i in 1...blockTypesLength {
            let block = DraggableBlock(name: blockTypes[i - 1])
            if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: gameplayAnchor.x - 150 + CGFloat(i - 1)*75, y: gameplayAnchor.y - 255)
                spriteComponent.node.zPosition = ZPositionsCategories.draggableBlock
                spriteComponent.node.size = CGSize(width: 60, height: 50)
            }
            entityManager.add(block)
        }
    }
    
    // MARK: Draw Auxiliary Tabs
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
    
    // MARK: Clear Tabs
    func clearTab (tabName: String) {
        var soundVerification = false
        switch tabName {
        case "command":
            for block in commandBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            if !commandBlocks.isEmpty{
                soundVerification = true
            }
            commandBlocks.removeAll()
        case "function":
            for block in functionBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            if !functionBlocks.isEmpty{
                soundVerification = true
            }
            functionBlocks.removeAll()
        case "loop":
            for block in loopBlocks {
                if let spriteComponent = block.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.removeFromParent()
                }
            }
            if !loopBlocks.isEmpty{
                soundVerification = true
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
        if !conditionalIfBlocks.isEmpty || !conditionalElseBlocks.isEmpty{
            soundVerification = true
        }
        conditionalIfBlocks.removeAll()
        conditionalElseBlocks.removeAll()
        default:
            break
        }
        print(soundVerification)
        if soundVerification {
            if  UserDefaults.standard.object(forKey: "SettingsSound") != nil {
                if (UserDefaults.standard.object(forKey: "SettingsSound") as? String) == "Sim"{
                    startDumpSound()
                }
            }else{
                startDumpSound()
            }
        }
    }
    
    // MARK: Draw Hud
    func drawnReturnButton() {
        let returnButton = HudButton(name: "return-button")
        if let spriteComponent = returnButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(returnButton)
    }
    func drawnConfigButton() {
        let configButton = HudButton(name: "config-button")
        if let spriteComponent = configButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(configButton)
    }
    func drawnHintButton() {
        let hintButton = HudButton(name: "hint-button")
        if let spriteComponent = hintButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.maxX - 100, y: frame.maxY - 50)
            spriteComponent.node.zPosition = ZPositionsCategories.button
        }
        entityManager.add(hintButton)
    }
    
    // MARK: Draw Boxes
    func drawBoxes () {
        for i in 0..<boxes.count {
            let box = DefaultObject(name: "box (\(boxes[i].x) - \(boxes[i].y)", spriteName: "box")
            if let spriteComponent = box.component(ofType: SpriteComponent.self) {
                let x = gameplayAnchor.x + CGFloat(32 * (boxes[i].x - 1)) - CGFloat(32 * (boxes[i].y - 1))
                let y = gameplayAnchor.y + 182 - CGFloat(16 * (boxes[i].x - 1)) - CGFloat(16 * (boxes[i].y - 1))
                spriteComponent.node.position = CGPoint(x: x, y: y)
                    //spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(boxes[i].x + boxes[i].y) + 1
                if let robot = robot.component(ofType: SpriteComponent.self){
                    spriteComponent.node.zPosition = (robot.node.zPosition - 0.2)
                }
            }
            boxesCopy.append(box)
            entityManager.add(box)
    
        }
        
        
    }
    
    
    
    // MARK: Draw Box Drop zones
    func drawBoxDropZones () {
        for i in 0..<boxDropZones.count {
            let boxDropZone = DefaultObject(name: "box-drop-zone (\(boxDropZones[i].x) - \(boxDropZones[i].y)", spriteName: "box-empty-floor")
            if let spriteComponent = boxDropZone.component(ofType: SpriteComponent.self) {
                let x = gameplayAnchor.x + CGFloat(32 * (boxDropZones[i].x - 1)) - CGFloat(32 * (boxDropZones[i].y - 1))
                let y = gameplayAnchor.y + 168 - CGFloat(16 * (boxDropZones[i].x - 1)) - CGFloat(16 * (boxDropZones[i].y - 1))
                spriteComponent.node.position = CGPoint(x: x, y: y)
                spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat( Int(actualPosition.x) +  Int(actualPosition.y))  - 0.4
            }
            entityManager.add(boxDropZone)
        }
        if let boxFloor = boxFloor.component(ofType: SpriteComponent.self){
            let x = gameplayAnchor.x + CGFloat(32 * (boxDropZones[0].x - 1)) - CGFloat(32 * (boxDropZones[0].y - 1))
            let y = gameplayAnchor.y + 168 - CGFloat(16 * (boxDropZones[0].x - 1)) - CGFloat(16 * (boxDropZones[0].y - 1))
            boxFloor.node.position = CGPoint(x: x, y: y)
            boxFloor.node.zPosition = -1
        }
        if let robot = robot.component(ofType: RobotMoveComponent.self){
            robot.boxFloor = boxFloor
        }
        entityManager.add(boxFloor)
    }
    
    // MARK: Update Texts
    func updateLoopText () {
        loopText.text = "\(loopValue)x"
    }
    
    func updateConditionalText () {
        conditionalText.text = conditions[conditionalValue]
    }
}
