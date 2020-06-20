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
        let faseAtual = UserDefaults.standard.object(forKey: "selectedFase")
        let stageOptional = BaseOfStages.buscar(id: "\(faseAtual!)")
        
        guard let stage = stageOptional else {
            return
        }
        //boxesCopy.removeAll()
         // resetar os as orientações
         actualPosition = CGPoint(x: stage.initialPosition[0], y: stage.initialPosition[1])
         actualDirection = stage.initialDirection
         
         // redesenhar o lightFloor
         if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
             let x = gameplayAnchor.x + CGFloat(32 * (actualPosition.x)) - CGFloat(32 * (actualPosition.y))
             let y = gameplayAnchor.y + 200 - CGFloat(16 * (actualPosition.x)) - CGFloat(16 * (actualPosition.y))
             spriteComponent.node.position = CGPoint(x: x, y: y)
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
        verificationBox = false
        if !stage.boxes.isEmpty{
            boxes = [CGPoint(x: stage.boxes[0], y: stage.boxes[1])]
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
                spriteComponent.node.run(SKAction.fadeIn(withDuration: 0))
            }
            i += 1
        }
        
        
        if let boxFloor = boxFloor.component(ofType: SpriteComponent.self){
            boxFloor.node.zPosition = -1
        }
        
        countBoxes = boxes.count
        if let removeElement = robot.component(ofType: RobotMoveComponent.self){
            removeElement.arrayPositionBox.removeAll()
            removeElement.arrayActualPosition.removeAll()
            removeElement.i = 0
            removeElement.arrayCheckerBox.removeAll()
            removeElement.arrayDirection.removeAll()
            removeElement.arrayClosures.removeAll()
        }
        if !stage.infectedRobots.isEmpty{
            if let spriteComponent = robotInfected.component(ofType: SpriteComponent.self) {
                spriteComponent.node.run(SKAction.fadeIn(withDuration: 0))
            }
            countInfected = stage.infectedRobots.count/2
        }
        
     }
     
    // MARK: Turn Robot
     func turnRobot(direction: String) {
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
         if let addElement = robot.component(ofType: RobotMoveComponent.self) {
            addElement.arrayDirection.append(actualDirection)
            addElement.arrayClosures.append(addElement.turn)
            if verificationBox {
                addElement.arrayCheckerBox.append(true)
            }else{
                addElement.arrayCheckerBox.append(false)
            }
         }
     }
    // MARK: Save
    func save(countMove: Double) -> Bool{
        switch actualDirection {
        case "up":
           if !infectedRobots.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)){
                return false
            }
        case "left":
           if !infectedRobots.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)){
                return false
            }
        case "down":
           if !infectedRobots.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)){
                return false
            }
        case "right":
           if !infectedRobots.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)){
                return false
            }
        default:
            return false
        }
        countInfected -= 1
        if countInfected == 0{
            if let sprite = robot.component(ofType: SpriteComponent.self){
                sprite.node.run(SKAction.wait(forDuration: countMove + 0.5)){
                    self.drawDialogues(won: true)
                }
            }
        }
        if let addElement = robot.component(ofType: RobotMoveComponent.self){
            addElement.arrayCheckerBox.append(false)
            addElement.arrayDirection.append(actualDirection)
            addElement.arrayClosures.append(addElement.saveRobot)
        }
        
        return true
    }
    // MARK: Put Box
    func putBox(countMove: Double) -> Bool{
        let positionBox: CGPoint
        switch actualDirection {
        // sabendo a direcao do robot
            // é verificado se o robot está na extremidade ou se onde ele quer soltar o box tem caixa
            // caso alguns dessas seja vdd nao será possivel colocar o box
        case "up":
           if actualPosition.y == 0 || boxes.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) {
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
            }
        case "left":
            if actualPosition.x == 0 || boxes.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) {
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
            }
        case "down":
            if actualPosition.y == stageDimensions.height - 1 || boxes.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) {
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
            }
        case "right":
            if actualPosition.x == stageDimensions.width - 1 || boxes.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) {
               return false
            } else {
                positionBox = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
            }
        default:
            positionBox = CGPoint(x: 0, y: 0)
            return false
        }
        
        boxes[identifierBox!] = positionBox
        if let box = boxesCopy[identifierBox!].component(ofType: SpriteComponent.self){
            // x, y e z sao para setar a nova posicao do box
            let x = gameplayAnchor.x + CGFloat(32 * (positionBox.x - 1)) - CGFloat(32 * (positionBox.y - 1))
            let y = gameplayAnchor.y + 182 - CGFloat(16 * (positionBox.x - 1)) - CGFloat(16 * (positionBox.y - 1))
            let z = stageDimensions.width + stageDimensions.height + CGFloat(positionBox.x + positionBox.y) + 1.2
            
            //box.node.position = CGPoint(x: x, y: y)
            box.node.name = "box (\(positionBox.x) - \(positionBox.y)"
            for drop in boxDropZones{
               if drop == positionBox {
                    countBoxes -= 1
                }
            }
            if countBoxes == 0{
                box.node.run(SKAction.wait(forDuration: countMove)){
                    self.drawDialogues(won: true)
                }
            }
            
            // posiciona o box no local indicado
            if let addElement = robot.component(ofType: RobotMoveComponent.self){
                addElement.arrayPositionBox.append(positionBox)
                addElement.arrayDirection.append(actualDirection)
                addElement.arrayCheckerBox.append(true)
                addElement.arrayClosures.append(addElement.putBox)
                addElement.arrayActualPosition.append(CGPoint(x: x, y: y))
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
           if !boxes.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
            }
        case "left":
            if !boxes.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
            }
        case "down":
            if !boxes.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
            }
        case "right":
            if !boxes.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)){
                return false
            } else {
                positionBox = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
            }
        default:
            positionBox = CGPoint(x: 0, y: 0)
            return false
        }
        if let addElement = robot.component(ofType: RobotMoveComponent.self){
            addElement.arrayCheckerBox.append(true)
            addElement.arrayDirection.append(actualDirection)
            addElement.arrayClosures.append(addElement.grabBox)
        }
        var i = 0
        // saber qual box o robot está pegando
        for box in boxesCopy{
            if let component = box.component(ofType: SpriteComponent.self){
                if component.node.name == "box (\(positionBox.x) - \(positionBox.y)" {
                    // guardando no idenfierBox o indice do box
                    identifierBox = i
                }
            }
            i+=1
        }
        //muda a posicao do box para o mesma do robot permitindo assim a
        //o robot de andar por onde a caixa tava sem restricao
        boxes[identifierBox!] = actualPosition
        
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
            if (actualPosition.y == 0) || boxes.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) || boxDropZones.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) || infectedRobots.contains(CGPoint(x: actualPosition.x, y: actualPosition.y - 1)) {
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
                 newZPosition = -1
             }
         case "left":
             if (actualPosition.x == 0) || boxes.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) || boxDropZones.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) || infectedRobots.contains(CGPoint(x: actualPosition.x - 1, y: actualPosition.y)) {
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
                 newZPosition = -1
             }
         case "down":
             if (actualPosition.y == stageDimensions.height - 1) || boxes.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) || boxDropZones.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)) || infectedRobots.contains(CGPoint(x: actualPosition.x, y: actualPosition.y + 1)){
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
                 newZPosition = 1
             }
         case "right":
             if (actualPosition.x == stageDimensions.width - 1) || boxes.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) || boxDropZones.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) || infectedRobots.contains(CGPoint(x: actualPosition.x + 1, y: actualPosition.y)) {
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
        if let addElement = robot.component(ofType: RobotMoveComponent.self){
            if verificationBox {
                boxes[identifierBox!] = actualPosition
                addElement.arrayCheckerBox.append(true)
            }else{
                addElement.arrayCheckerBox.append(false)
            }
            addElement.arrayDirection.append(actualDirection)
            addElement.arrayClosures.append(addElement.move)
        }
        
        // ajustamos sua zPosition
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            spriteComponent.node.zPosition = spriteComponent.node.zPosition + newZPosition
        }
        
        // ajustamos sua zPosition
        if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
            spriteComponent.node.zPosition = spriteComponent.node.zPosition + newZPosition
        }
         return true
     }
    // MARK: Move Light floor
     func moveCompleteRobotLightFloor(){
         if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
            robotMoveComponent.moveComplete(arrayBox: boxesCopy, stopButton: stopButton, robotInfected: robotInfected, lightFloor: lightFloor)
         }
     }
}
