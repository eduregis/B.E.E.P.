//
//  DrawGame.swift
//  B.E.E.P.
//
//  Created by samuel sales on 12/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation
class DrawGame: GameScene{
    
    // desenha o tileset e seu corredor de luz de acordo com sua posição
       func drawTilesets(width: Int, height: Int) {
           for i in 1...width {
               for j in 1...height {
                   
                   // desenha o tileset
                   let tileset = Tileset()
                   if let spriteComponent = tileset.component(ofType: SpriteComponent.self) {
                    let x = super.gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = super.gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                       spriteComponent.node.position = CGPoint(x: x, y: y)
                       spriteComponent.node.zPosition = CGFloat(i + j)
                   }
                    super.entityManager.add(tileset)
                   
                   // desenha a luz do tileset
                   let light = Light(xPosition: i, yPosition: j, maxX: width, maxY: height)
                   if let spriteComponent = light.component(ofType: SpriteComponent.self) {
                    let x = super.gameplayAnchor.x + CGFloat(32 * (i - 1)) - CGFloat(32 * (j - 1))
                    let y = super.gameplayAnchor.y + 200 - CGFloat(16 * (i - 1)) - CGFloat(16 * (j - 1))
                       spriteComponent.node.position = CGPoint(x: x, y: y)
                       spriteComponent.node.zPosition = CGFloat(i + j + 2)
                   }
                   entityManager.add(light)
               }
           }
       }
       
     /*  func drawRobot (xPosition: Int, yPosition: Int) {
           // desenha o chão iluminado embaixo do robô
           if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
               let x = gameplayAnchor.x + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
               let y = gameplayAnchor.y + 200 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
               spriteComponent.node.position = CGPoint(x: x, y: y)
               spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition)
               spriteComponent.node.alpha = 0.6
           }
           entityManager.add(lightFloor)
           
           // desenha o robô
           if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
               let x = gameplayAnchor.x + CGFloat(32 * (xPosition - 1)) - CGFloat(32 * (yPosition - 1))
               let y = gameplayAnchor.y + 236 - CGFloat(16 * (xPosition - 1)) - CGFloat(16 * (yPosition - 1))
               spriteComponent.node.position = CGPoint(x: x, y: y)
               spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(xPosition + yPosition + 1)
           }
           entityManager.add(robot)
       }*/
       
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
           
           /*// botão de stop
           if let spriteComponent = stopButton.component(ofType: SpriteComponent.self) {
               spriteComponent.node.position = CGPoint(x: gameplayAnchor.x + 170, y: gameplayAnchor.y - 115)
               spriteComponent.node.zPosition = 0
           }
           entityManager.add(stopButton)*/
           
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
                   yAjust = 0
               }
               let auxiliaryTab = AuxiliaryTab(size: size)
               if let spriteComponent = auxiliaryTab.component(ofType: SpriteComponent.self) {
                   spriteComponent.node.position = CGPoint(x: auxiliaryAnchor.x, y: auxiliaryAnchor.y + yAjust)
                   spriteComponent.node.zPosition = ZPositionsCategories.tab
               }
               entityManager.add(auxiliaryTab)
               drawFunctionTab()
           }
       }
       
       func drawFunctionTab() {
           // adiciona a aba de comandos
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
