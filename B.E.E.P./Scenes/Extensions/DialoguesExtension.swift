//
//  DialoguesExtension.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 15/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
   
    func drawDialogues(won: Bool) {

        dialogueIndex = 0
        let animateDuration = 0.3
        let animateVector = 50
        let dialogueAnchor = CGPoint(x: frame.midX - 64, y: frame.midY/3 + 50)
        // adicionando fundo escuro
        dialogueBackground = DefaultObject(name: "dialogue-background", spriteName: "dialogue-background", size: CGSize(width: frame.width, height: frame.height))
        if let spriteComponent = dialogueBackground.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX, y: frame.midY)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueBackground
            spriteComponent.node.alpha = 0
            spriteComponent.node.run(SKAction.fadeAlpha(to: 0.6, duration: animateDuration))
        }
        entityManager.add(dialogueBackground)
        
        // adicionando B.E.E.P.
        beep = DefaultObject(name: "beep", spriteName: "beep-1", size: CGSize(width: 256, height: 256))
        if let spriteComponent = beep.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX/3 - CGFloat(animateVector), y: frame.minY + spriteComponent.node.size.height/2)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
            spriteComponent.node.alpha = 0
            let fadeToLeft = SKAction.group([
                SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 1, duration: 0.5)])
            spriteComponent.node.run(fadeToLeft)
        }
        entityManager.add(beep)
        
        // adicionando caixa de diálogo
        dialogueTab = DefaultObject(name: "beep-dialogue", spriteName: "beep-dialogue")
        if let spriteComponent = dialogueTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: dialogueAnchor.x + 128 + CGFloat(animateVector), y: dialogueAnchor.y)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueTab
            spriteComponent.node.alpha = 0
            let fadeToRight = SKAction.group([
                SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 1, duration: 0.5)])
            spriteComponent.node.run(fadeToRight)
        }
        entityManager.add(dialogueTab)
        if !won {
            dialogueText = SKLabelNode(text: dialogues[dialogueIndex])
            dialogueText.fontSize = 14.0
        } else{
            dialogueText = SKLabelNode(text: "Perfeito!")
            dialogueText.fontSize = 18.0
        }
        dialogueText.fontName = "8bitoperator"

        dialogueText.fontColor = .textRoyal
        dialogueText.zPosition = ZPositionsCategories.dialogueItems
        dialogueText.position = CGPoint(x: dialogueAnchor.x - 138 + CGFloat(animateVector), y: dialogueAnchor.y + 20)
        dialogueText.verticalAlignmentMode = .top
        dialogueText.horizontalAlignmentMode = .left
        dialogueText.numberOfLines = 2
        dialogueText.alpha = 0
        let fadeToRight = SKAction.group([
            SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
            SKAction.fadeAlpha(to: 1, duration: 0.5)])
        dialogueText.run(fadeToRight)
        addChild(dialogueText)
        
        let namePlay: String
        if won {
            namePlay = "next-button"
        }else{
            namePlay = "play-dialogue"
        }
        // adiciona botão para avançar para o próximo diálogo
        dialogueButton = DefaultObject(name: namePlay, spriteName: "play-dialogue")

        if let spriteComponent = dialogueButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: dialogueAnchor.x + 380 + CGFloat(animateVector), y: dialogueAnchor.y - 45)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
            spriteComponent.node.alpha = 0
            let fadeToRight = SKAction.group([
                SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 1, duration: 0.5)])
            spriteComponent.node.run(fadeToRight)
            //            let pulsed = SKAction.sequence([
            //                SKAction.resize(byWidth: 10, height: 10, duration: 0.5),
            //                SKAction.resize(byWidth: -10, height: -10, duration: 0.5)])
            //            spriteComponent.node.run(SKAction.repeatForever(pulsed))
        }
        entityManager.add(dialogueButton)
    
        // adiciona botão para avançar para o próximo diálogo
        
        if !won {
            dialogueSkip = DefaultObject(name: "skip-button")
            if let spriteComponent = dialogueSkip.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: dialogueAnchor.x + 378 + CGFloat(animateVector), y: dialogueAnchor.y - 125)
                spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
                spriteComponent.node.alpha = 0
                let fadeToRight = SKAction.group([
                    SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
                    SKAction.fadeAlpha(to: 1, duration: 0.5)])
                spriteComponent.node.run(fadeToRight)
            }
            
            entityManager.add(dialogueSkip)
        }

    }
    
    func updateText () {
        if dialogueIndex < dialogues.count - 1 {
            dialogueIndex = dialogueIndex + 1
            dialogueText.text = dialogues[dialogueIndex]
        } else {
            skipText(next: false)
        }
    }
    
    func hintStage () {
        drawDialogues(won: false)
    }
    
    func skipText (next: Bool) {

        let animateDuration = 0.3
        let animateVector = 50
        if let spriteComponent = dialogueBackground.component(ofType: SpriteComponent.self) {
            spriteComponent.node.run(SKAction.fadeAlpha(to: 0, duration: animateDuration)) {
                self.entityManager.remove(self.dialogueBackground)
            }
        }
        if let spriteComponent = beep.component(ofType: SpriteComponent.self) {
            let backToLeft = SKAction.group([
                SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 0, duration: animateDuration)])
            spriteComponent.node.run(backToLeft) {
                self.entityManager.remove(self.beep)
            }
        }
        if let spriteComponent = dialogueButton.component(ofType: SpriteComponent.self) {
            let backToRight = SKAction.group([
                SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 0, duration: animateDuration)])
            spriteComponent.node.run(backToRight) {
                self.entityManager.remove(self.dialogueButton)
            }
        }
        if let spriteComponent = dialogueTab.component(ofType: SpriteComponent.self) {
            let backToRight = SKAction.group([
                SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 0, duration: animateDuration)])
            spriteComponent.node.run(backToRight) {
                self.entityManager.remove(self.dialogueTab)
            }
        }
        if let spriteComponent = dialogueSkip.component(ofType: SpriteComponent.self) {
            let backToRight = SKAction.group([
                SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
                SKAction.fadeAlpha(to: 0, duration: animateDuration)])
            spriteComponent.node.run(backToRight) {
                self.entityManager.remove(self.dialogueSkip)
            }
        }
        let backToRight = SKAction.group([
            SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
            SKAction.fadeAlpha(to: 0, duration: animateDuration)])
        dialogueText.run(backToRight) {
            self.dialogueText.removeFromParent()

            if next {
                self.returnToMap()
            }

        }
    }
}
