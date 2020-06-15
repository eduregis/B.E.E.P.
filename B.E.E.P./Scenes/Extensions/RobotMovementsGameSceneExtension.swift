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
             let y = gameplayAnchor.y + 236 - CGFloat(16 * (actualPosition.x)) - CGFloat(16 * (actualPosition.y))
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
        
        verificationBox = false
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
             elementArrayMove = robotMoveComponent.turn(direction: actualDirection, box: verificationBox)
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
        let animate = SKAction.animate(with: texture, timePerFrame: 0)
        arrayMoveRobot.append(animate)
        
    }
    // MARK: Grab Box
    func grabBox(countMove: Int) -> Bool{
        var positionBox: CGPoint
        if verificationBox  == true {
            switch actualDirection {
            case "up":
               if actualPosition.y == 0 {
                    return false
                } else {
                    positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
                }
            case "left":
                if actualPosition.x == 0 {
                    return false
                } else {
                    positionBox = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
                }
            case "down":
                if actualPosition.y == stageDimensions.height - 1 {
                    return false
                } else {
                    positionBox = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
                }
            case "right":
                if actualPosition.x == stageDimensions.width - 1 {
                   return false
                } else {
                    positionBox = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
                }
            default:
                positionBox = CGPoint(x: 0, y: 0)
                return false
            }
            if let box = boxesCopy[identifierBox!].component(ofType: SpriteComponent.self){
                let x = gameplayAnchor.x + CGFloat(32 * (positionBox.x - 1)) - CGFloat(32 * (positionBox.y - 1))
                let y = gameplayAnchor.y + 182 - CGFloat(16 * (positionBox.x - 1)) - CGFloat(16 * (positionBox.y - 1))
                let z = stageDimensions.width + stageDimensions.height + CGFloat(positionBox.x + positionBox.y) + 1
                textureRobotDirection()
                box.node.run(SKAction.wait(forDuration: Double(countMove)*0.75)){
                    box.node.position = CGPoint(x: x, y: y)
                    box.node.zPosition = z
                }
            }
            verificationBox = false
            return true
        }
        
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
        for box in boxesCopy{
            if let component = box.component(ofType: SpriteComponent.self){
                if component.node.name == "box (\(positionBox.x) - \(positionBox.y)" {
                    identifierBox = i
                    component.node.run(SKAction.wait(forDuration: Double(countMove)*0.65)){
                        component.node.zPosition = 0
                    }
                }
            }
            i+=1
        }
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
        print(actualPosition.x, actualPosition.y)
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
