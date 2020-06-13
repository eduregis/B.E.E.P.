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
             let x = gameplayAnchor.x + CGFloat(32 * (actualPosition.x - 1)) - CGFloat(32 * (actualPosition.y - 1))
             let y = gameplayAnchor.y + 200 - CGFloat(16 * (actualPosition.x - 1)) - CGFloat(16 * (actualPosition.y - 1))
             spriteComponent.node.position = CGPoint(x: x, y: y)
             //spriteComponent.node.zPosition = CGFloat(actualPosition.x + actualPosition.y + 1)
             spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(actualPosition.x + actualPosition.y)
     }
         
         // redesenhar o robot
         if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
             spriteComponent.node.texture = SKTexture(imageNamed: "robot-idle-\(actualDirection)-2")
             let x = gameplayAnchor.x + CGFloat(32 * (actualPosition.x - 1)) - CGFloat(32 * (actualPosition.y - 1))
             let y = gameplayAnchor.y + 236 - CGFloat(16 * (actualPosition.x - 1)) - CGFloat(16 * (actualPosition.y - 1))
             spriteComponent.node.position = CGPoint(x: x, y: y)
             spriteComponent.node.zPosition = stageDimensions.width + stageDimensions.height + CGFloat(actualPosition.x + actualPosition.y + 1)
         }
     }
     
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
             elementArrayMove = robotMoveComponent.turn(direction: actualDirection)
         }
         // adicionamos uma -move da lightFloor default- para igualar o tempo de reação do lightFloor com a do robot
         if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
             arrayMovelightFloor.append(lightFloorMoveComponent.move(direction: ""))
         }
         return elementArrayMove!
     }
    
     func moveRobot() -> Bool {
         // checa se o robô pode andar para a posição apontada
         switch actualDirection {
         case "up":
             if (actualPosition.y == 1) {
                 return false
                 
             } else {
                 actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y - 1)
             }
         case "left":
             if (actualPosition.x == 1) {
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x - 1, y: actualPosition.y)
             }
         case "down":
             if (actualPosition.y == stageDimensions.height) {
                 return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y + 1)
             }
         case "right":
             if (actualPosition.x == stageDimensions.width) {
                return false
             } else {
                 actualPosition = CGPoint(x: actualPosition.x + 1, y: actualPosition.y)
             }
         default:
             actualPosition = CGPoint(x: actualPosition.x, y: actualPosition.y)
         }
         
         //Caso ele possa andar
         // adiconamos a SKAction referente a direção atual no arrayMoveRobot
         if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
             arrayMoveRobot.append(robotMoveComponent.move(direction: actualDirection))
         }
         
         // adiconamos a SKAction referente a direção atual no arrayMoveLightFLoor
         if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
             arrayMovelightFloor.append(lightFloorMoveComponent.move(direction: actualDirection))
         }
         
         return true
     }
     
     func moveCompleteRobotLightFloor(){
         if let lightFloorMoveComponent = lightFloor.component(ofType: LightFloorMoveComponent.self) {
             lightFloorMoveComponent.moveComplete(move: arrayMovelightFloor)
         }
         if let robotMoveComponent = robot.component(ofType: RobotMoveComponent.self) {
             robotMoveComponent.moveComplete(move: arrayMoveRobot, button: stopButton)
         }
     }
}
