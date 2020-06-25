//
//  TouchesBeganGameSceneExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 23/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            // Checamos o nome do SpriteNode que foi detectado pela função
            if (self.atPoint(location).name == "walk-block") || (self.atPoint(location).name == "turn-left-block") || (self.atPoint(location).name == "turn-right-block") || (self.atPoint(location).name == "grab-block") || (self.atPoint(location).name == "save-block") || (self.atPoint(location).name == "function-block") || (self.atPoint(location).name == "loop-block") || (self.atPoint(location).name == "conditional-block") {
                // passamos o objeto detectado para dentro do selectedItem
                selectedItem = self.atPoint(location) as? SKSpriteNode
            }
            else {
                // caso não seja o objeto que queremos, esvaziamos o selectedItem
                selectedItem = nil
                if self.atPoint(location).name == "play-button" {
                    if  UserDefaults.standard.object(forKey: "SettingsSound") != nil {
                        if (UserDefaults.standard.object(forKey: "SettingsSound") as? String) == "Sim"{
                            startPlaySound()
                        }
                    }else{
                        startPlaySound()
                    }

                    
                    /*verificar se o array commandBlocks está vazio
                     - Se tem algum block na dropZone*/
                    if !commandBlocks.isEmpty {
                        // rodamos commandBlocks para guardar as SKAction referente a cada block colocado na dropZone
                        for block in commandBlocks{
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
                                case "function-block":
                                    addElementFunc()
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
                                case "loop-block":
                                    addElementLoop()
                                case "conditional-block":
                                    addElementConditional()
                                default:
                                    break;
                                }
                                
                            }
                            
                        }
                        if let stopButton = stopButton.component(ofType: SpriteComponent.self){
                            stopButton.node.zPosition = ZPositionsCategories.button + 1
                        }
                        //execução do array actionMove que permitirar uma movimentação linear sem desvios
                        moveCompleteRobotLightFloor()
                    }
                } else if (self.atPoint(location).name == "stop-button") {
                    if let stop = robot.component(ofType: RobotMoveComponent.self){
                        stop.stopButtonAction()
                        /*if let pause = robot.component(ofType: SpriteComponent.self){
                            pause.node.run(SKAction.wait(forDuration: 0.8)){
                                self.resetMoveRobot()
                            }
                        }*/
                    }
                } else if (self.atPoint(location).name == "play-dialogue") {
                    updateText()
                } else if (self.atPoint(location).name == "skip-button") {
                    skipText(next: false)
                } else if (self.atPoint(location).name == "next-button") {
                    skipText(next: true)
                }else if (self.atPoint(location).name == "hint-button") {
                    hintStage()
                } else if (self.atPoint(location).name == "command-clear-tab") {
                    if let stopButton = stopButton.component(ofType: SpriteComponent.self){
                        print(stopButton.node.zPosition)
                        if !commandBlocks.isEmpty && stopButton.node.zPosition != -1 {
                            if let stop = robot.component(ofType: RobotMoveComponent.self){
                                stop.stopButtonAction()
                            }
                        }
                    }
                    clearTab(tabName: "command")
                } else if (self.atPoint(location).name == "function-clear-tab") {
                    clearTab(tabName: "function")
                } else if (self.atPoint(location).name == "loop-clear-tab") {
                    clearTab(tabName: "loop")
                } else if (self.atPoint(location).name == "loop-arrow-left") {
                    if loopValue > 1 {
                        loopValue = loopValue - 1
                    }
                    if let spriteComponent = loopArrows[1].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if loopValue == 1 {
                        if let spriteComponent = loopArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = loopArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateLoopText()
                } else if (self.atPoint(location).name == "loop-arrow-right") {
                    if loopValue < 4 {
                        loopValue = loopValue + 1
                    }
                    if let spriteComponent = loopArrows[0].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if loopValue == 4 {
                        if let spriteComponent = loopArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = loopArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateLoopText()
                } else if (self.atPoint(location).name == "conditional-clear-tab") {
                    clearTab(tabName: "conditional")
                } else if (self.atPoint(location).name == "conditional-arrow-left") {
                    if conditionalValue > 0 {
                        conditionalValue = conditionalValue - 1
                    }
                    if let spriteComponent = conditionalArrows[1].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if conditionalValue == 0 {
                        if let spriteComponent = conditionalArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = conditionalArrows[0].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateConditionalText()
                } else if (self.atPoint(location).name == "conditional-arrow-right") {
                    if conditionalValue < 3 {
                        conditionalValue = conditionalValue + 1
                    }
                    if let spriteComponent = conditionalArrows[0].component(ofType: SpriteComponent.self) {
                        spriteComponent.node.alpha = 1
                    }
                    if conditionalValue == 3 {
                        if let spriteComponent = conditionalArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 0.3
                        }
                    } else {
                        if let spriteComponent = conditionalArrows[1].component(ofType: SpriteComponent.self) {
                            spriteComponent.node.alpha = 1
                        }
                    }
                    updateConditionalText()
                }
            }
            if let oldName = self.atPoint(location).name {
                // testa se selecionamos um bloco dentro da aba de comandos
                if oldName.contains("-dropped-") {
                    // se sim, utilizamos o trecho "-dropped-" para separar obtermos o nome original e seu índice
                    var newName: [String] = []
                    var arrayName: String = ""
                    if oldName.contains("-dropped-command-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-command-")
                        arrayName = "command-"
                    } else if oldName.contains("-dropped-function-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-function-")
                        arrayName = "function-"
                    } else if oldName.contains("-dropped-loop-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-loop-")
                        arrayName = "loop-"
                    } else if oldName.contains("-dropped-conditional-if-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-conditional-if-")
                        arrayName = "conditional-if-"
                    } else if oldName.contains("-dropped-conditional-else-") {
                        newName = self.atPoint(location).name!.components(separatedBy: "-dropped-conditional-else-")
                        arrayName = "conditional-else-"
                    }
                    let newBlock = self.atPoint(location) as? SKSpriteNode
                    // removemos o sprite do bloco na tela, este passando a existir apenas no selectedItem à seguir
                    self.atPoint(location).removeFromParent()
                    // passamos apenas o nome original para o selectedItem
                    newBlock?.name = newName[0]
                    selectedItem = newBlock
                    // caso ele não seja o último da fila, precisamos trazer tudo à direita dele um passo para a esquerda.
                    if let indexToRemove = Int(newName[1]) {
                        // removemos o o bloco do array
                        switch arrayName {
                        case "command-":
                            commandBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<commandBlocks.count {
                                if let spriteComponent = commandBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-command-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-command-\(newIndex)"
                                }
                            }
                        case "function-":
                            functionBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<functionBlocks.count {
                                if let spriteComponent = functionBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-function-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-function-\(newIndex)"
                                }
                            }
                        case "loop-":
                            loopBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<loopBlocks.count {
                                if let spriteComponent = loopBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-loop-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-loop-\(newIndex)"
                                }
                            }
                        case "conditional-if-":
                            conditionalIfBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<conditionalIfBlocks.count {
                                if let spriteComponent = conditionalIfBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-conditional-if-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-conditional-if-\(newIndex)"
                                }
                            }
                        case "conditional-else-":
                            conditionalElseBlocks.remove(at: indexToRemove)
                            // trazemos os blocos para a esquerda, ajustando tanto a posição do sprite quanto seu índice no final do nome
                            for index in indexToRemove..<conditionalElseBlocks.count {
                                if let spriteComponent = conditionalElseBlocks[index].component(ofType: SpriteComponent.self) {
                                    spriteComponent.node.position = CGPoint(x: spriteComponent.node.position.x - 50, y: spriteComponent.node.position.y)
                                    // a partir do nome antigo, remontamos dessa forma
                                    let oldIndex = spriteComponent.node.name?.components(separatedBy: "-dropped-conditional-else-")
                                    let newIndex = Int(oldIndex![1])! - 1
                                    spriteComponent.node.name = "\(oldIndex![0])-dropped-conditional-else-\(newIndex)"
                                }
                            }
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}
