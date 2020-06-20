//
//  RobotMovementsExtensions.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 13/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import GameplayKit
import SpriteKit

extension GameScene {
    
    // MARK: Reset Move Robot
     func resetMoveRobot(){
         // remover todos os elementos de todos os arrays referentes ao movimento do robot e lightFloor
         arrayMoveRobot.removeAll()
         arrayMovelightFloor.removeAll()
        //boxesCopy.removeAll()
         // resetar os as orientações
         actualPosition = CGPoint(x: 1, y: 1)
         actualDirection = "right"
         
         //colocando o botão de stop para traz
         if let stopButton = stopButton.component(ofType: SpriteComponent.self){
             stopButton.node.zPosition = 0
         }
         
         // redesenhar o lightFloor
         if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
             let x = gameplayAnchor.x + CGFloat(32 * (actualPosition.x)) - CGFloat(32 * (actualPosition.y))
             let y = gameplayAnchor.y + 200 - CGFloat(16 * (actualPosition.x)) - CGFloat(16 * (actualPosition.y))
             spriteComponent.node.position = CGPoint(x: x, y: y)
             //spriteComponent.node.zPosition = CGFloat(actualPosition.x + actualPosition.y + 1)
             spriteComponent.node.zPosition = CGFloat(actualPosition.x + actualPosition.y) + 3
     }
         
         // redesenhar o robot
         if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
             spriteComponent.node.texture = SKTexture(imageNamed: "robot-idle-\(actualDirection)-2")
             let x = gameplayAnchor.x + CGFloat(32 * (actualPosition.x)) - CGFloat(32 * (actualPosition.y))
             let y = gameplayAnchor.y + 232 - CGFloat(16 * (actualPosition.x)) - CGFloat(16 * (actualPosition.y))
             spriteComponent.node.position = CGPoint(x: x, y: y)
             spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(actualPosition.x + actualPosition.y + 1)
         }
        //redesenhar os boxes
        var i = 0
        for box in boxesCopy {
            if let spriteComponent = box.component(ofType: SpriteComponent.self) {
                let x = gameplayAnchor.x + CGFloat(32 * (boxes[i].x - 1)) - CGFloat(32 * (boxes[i].y - 1))
                let y = gameplayAnchor.y + 182 - CGFloat(16 * (boxes[i].x - 1)) - CGFloat(16 * (boxes[i].y - 1))
                spriteComponent.node.position = CGPoint(x: x, y: y)
                spriteComponent.node.name = "box (\(boxes[i].x) - \(boxes[i].y)"
                spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(boxes[i].x + boxes[i].y) + 1
            }
            i += 1
        }
        
        if let boxFloor = boxFloor.component(ofType: SpriteComponent.self){
            boxFloor.node.zPosition = -1
        }
        
        verificationBox = false
        
        for o in 0..<boxesChangeable.count{
            boxesChangeable[o] = boxes[o]
        }
        countBoxes = boxes.count
     }
     
    // MARK: Turn Robot
     func turnRobot(direction: String) -> SKAction {
         // checa para qual lado o robô irá girar
         switch direction {
         case "left":
             // gira de acordo com a direção do robô
             switch actualDirection {
             case "up":
                 actualDirection = "left"
             case "left":
                 actualDirection = "down"
             case "down":
                 actualDirection = "right"
             case "right":
                 actualDirection = "up"
             default:
                 break
             }
         case "right":
             switch actualDirection {
             case "up":
                 actualDirection = "right"
             case "left":
                 actualDirection = "up"
             case "down":
                 actualDirection = "left"
             case "right":
                 actualDirection = "down"
             default:
                 break
             }
         default:
             break
         }
         if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            if verificationBox {
                elementArrayMove = robotMoveComponent.turnBox(direction: actualDirection)
            }else{
                elementArrayMove = robotMoveComponent.turn(direction: actualDirection)
            }
             
         }
         // adicionamos uma -move da lightFloor default- para igualar o tempo de reação do lightFloor com a do robot
         if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
             arrayMovelightFloor.append(lightFloorMoveComponent.move(direction: ""))
         }
         return elementArrayMove!
     }
    func textureRobotDirection(){
        let texture: [SKTexture]
        switch actualDirection {
            case "up":
                texture = [SKTexture(imageNamed: "robot-idle-up-2")]
            case "left":
                texture = [SKTexture(imageNamed: "robot-idle-left-2")]
            case "down":
                texture = [SKTexture(imageNamed: "robot-idle-down-2")]
            case "right":
                texture = [SKTexture(imageNamed: "robot-idle-right-2")]
            default:
                texture = [SKTexture(imageNamed: "")]
        }
        let animate = SKAction.animate(with: texture, timePerFrame: 0.2)
        arrayMoveRobot.append(animate)
        if let floor = lightFloor.component(ofType: LightFloorMoveComponent.self){
            arrayMovelightFloor.append(floor.move(direction: ""))
        }
    }
    // MARK: Put Box
    func putBox(countMove: Double) -> Bool{
        let positionBox: CGPoint
        switch actualDirection {
        // sabendo a direcao do robot
            // é verificado se o robot está na extremidade ou se onde ele quer soltar o box tem caixa
            // caso alguns dessas seja vdd nao será possivel colocar o box
        case "up":
           if actualPosition.y == 0 || boxesChangeable.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) {
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
            }
        case "left":
            if actualPosition.x == 0 || boxesChangeable.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) {
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
            }
        case "down":
            if actualPosition.y == stageDimensions.height - 1 || boxesChangeable.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) {
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
            }
        case "right":
            if actualPosition.x == stageDimensions.width - 1 || boxesChangeable.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) {
               return false
            } else {
                positionBox = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
            }
        default:
            positionBox = CGPoint(x: 0, y: 0)
            return false
        }
        //print("position \(positionBox)")
        boxesChangeable[identifierBox!] = positionBox
        if let box = boxesCopy[identifierBox!].component(ofType: SpriteComponent.self){
            // x, y e z sao para setar a nova posicao do box
            let x = gameplayAnchor.x + CGFloat(32 * (positionBox.x - 1)) - CGFloat(32 * (positionBox.y - 1))
            let y = gameplayAnchor.y + 182 - CGFloat(16 * (positionBox.x - 1)) - CGFloat(16 * (positionBox.y - 1))
            let z = stageDimensions.width + stageDimensions.height + CGFloat(positionBox.x + positionBox.y) + 1.2
            
            //mudar de robot com box para robot sem box, lenvando em conta tambem sua direcao
            textureRobotDirection()
            
            // verificar se onde a caixa foi deixada corresponde a algum das boxDropZones
            for drop in boxDropZones{
                
                if positionBox == drop {
                    // caso vdd
                    // diminui um countBoxes que representa a quantidade de boxDropZones
                    countBoxes -= 1
                    
                    if let boxFloor = boxFloor.component(ofType: SpriteComponent.self){
                        // verBoxes serve para verificar se o todas as boxDropZone ja foram acionadas
                        var verBoxes = false
                        if countBoxes == 0 {
                            verBoxes = true
                        }
                        
                        let xfloor = gameplayAnchor.x + CGFloat(32 * (positionBox.x - 1)) - CGFloat(32 * (positionBox.y - 1))
                        let yfloor = gameplayAnchor.y + 168 - CGFloat(16 * (positionBox.x - 1)) - CGFloat(16 * (positionBox.y - 1))
                        let zfloor = stageDimensions.width + stageDimensions.height + CGFloat(positionBox.x + positionBox.y) + 1.1
                        
                        boxFloor.node.run(SKAction.wait(forDuration: countMove + 0.1)){
                            boxFloor.node.position = CGPoint(x: xfloor, y: yfloor)
                            boxFloor.node.zPosition = zfloor
                            if verBoxes {
                                self.drawDialogues(won: verBoxes)
                            }
                        }
                    }
                    
                }
                
            }
            if let boxCopy = boxesCopy[identifierBox!].component(ofType: SpriteComponent.self){
                boxCopy.node.name = "box (\(positionBox.x) - \(positionBox.y)"
            }
            // posiciona o box no local indicado
            box.node.run(SKAction.wait(forDuration: countMove)){
                box.node.name = "box (\(positionBox.x) - \(positionBox.y)"
                box.node.position = CGPoint(x: x, y: y)
                box.node.zPosition = CGFloat(z)
                
            }
        }
        
        // volta a indicar que o robot nao está com box
        verificationBox = false
        return true
    }
    
    // MARK: Grab Box
    func grabBox(countMove: Double) -> Bool{
        let positionBox: CGPoint
        
        switch actualDirection {
        case "up":
           if !boxesChangeable.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
            }
        case "left":
            if !boxesChangeable.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
            }
        case "down":
            if !boxesChangeable.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
            }
        case "right":
            if !boxesChangeable.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
            }
        default:
            positionBox = CGPoint(x: 0, y: 0)
            return false
        }
        if let robot = robot.component(ofType: RobotMoveComponent.self){
            arrayMoveRobot.append(robot.moveBoxe(direction: actualDirection))
        }
        
        var i = 0
        // saber qual box o robot está pegando
        for box in boxesCopy{
            if let component = box.component(ofType: SpriteComponent.self){
                if component.node.name == "box (\(positionBox.x) - \(positionBox.y)" {
                    // guardando no idenfierBox o indice do box
                    identifierBox = i
                    print("Achou")
                    component.node.run(SKAction.wait(forDuration: countMove)){
                        //escondendo o box, pois ele foi capturado
                        component.node.zPosition = -1
                    }
                }
            }
            i+=1
        }
        //muda a posicao do box para o mesma do robot permitindo assim a
        //o robot de andar por onde a caixa tava sem restricao
        boxesChangeable[identifierBox!] = actualPosition
        
        //indica que o robot está com um box
        verificationBox = true
        return true
    }
    
     // MARK: Move Robot
     func moveRobot() -> Bool {
        var newZPosition: CGFloat = 0
         // checa se o robô pode andar para a posição apontada
         switch actualDirection {
         case "up":
            if (actualPosition.y == 0) || boxesChangeable.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) || boxDropZones.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) || infectedRobots.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) {
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
                 newZPosition = -1
             }
         case "left":
             if (actualPosition.x == 0) || boxesChangeable.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) || boxDropZones.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) || infectedRobots.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) {
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
                 newZPosition = -1
             }
         case "down":
             if (actualPosition.y == stageDimensions.height - 1) || boxesChangeable.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) || boxDropZones.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) || infectedRobots.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)){
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
                 newZPosition = 1
             }
         case "right":
             if (actualPosition.x == stageDimensions.width - 1) || boxesChangeable.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) || boxDropZones.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) || infectedRobots.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) {
                return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
                 newZPosition = 1
             }
         default:
             actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y)
         }
        // caso o robot esteja com um box
        // a position do box deve ser igual a do robot
        if verificationBox {
            boxesChangeable[identifierBox!] = actualPosition
        }
        
         //Caso ele possa andar
         // adicionamos a SKAction referente a direção atual no arrayMoveRobot
         if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
             arrayMoveRobot.append(robotMoveComponent.move(direction: actualDirection, box: verificationBox))
         }
        
        // ajustamos sua zPosition
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            spriteComponent.node.zPosition = spriteComponent.node.zPosition + newZPosition
        }
         
         // adicionamos a SKAction referente a direção atual no arrayMoveLightFLoor
         if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
             arrayMovelightFloor.append(lightFloorMoveComponent.move(direction: actualDirection))
         }
        
        // ajustamos sua zPosition
        if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
            spriteComponent.node.zPosition = spriteComponent.node.zPosition + newZPosition
        }
         return true
     }
     
    // MARK: Move Light floor
     func moveCompleteRobotLightFloor(){
         if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
             lightFloorMoveComponent.moveComplete(move: arrayMovelightFloor)
         }
         if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.moveComplete(move: arrayMoveRobot, button: stopButton)
         }
     }
}
