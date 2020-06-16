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
    
    func drawDialogues() {
        let dialogueAnchor = CGPoint(x: frame.midX - 64, y: frame.midY/3 + 50)
        // adicionando fundo escuro
        dialogueBackground = DefaultObject(name: "dialogue-background", spriteName: "dialogue-background", size: CGSize(width: frame.width, height: frame.height))
        if let spriteComponent = dialogueBackground.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX, y: frame.midY)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueBackground
            spriteComponent.node.alpha = 0
            spriteComponent.node.run(SKAction.fadeAlpha(to: 0.6, duration: 0.5))
        }
        entityManager.add(dialogueBackground)
        
        // adicionando B.E.E.P.
        beep = DefaultObject(name: "beep", spriteName: "beep-1", size: CGSize(width: 256, height: 256))
        if let spriteComponent = beep.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX/3, y: frame.minY + spriteComponent.node.size.height/2)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
        }
        entityManager.add(beep)
        
        // adicionando caixa de diálogo
        dialogueTab = DefaultObject(name: "beep-dialogue", spriteName: "beep-dialogue")
        if let spriteComponent = dialogueTab.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: dialogueAnchor.x + 128, y: dialogueAnchor.y)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueTab
        }
        entityManager.add(dialogueTab)
        
        dialogueText = SKLabelNode(text: dialogues[dialogueIndex])
        dialogueText.fontName = "8bitoperator"
        dialogueText.fontSize = 14.0
        dialogueText.fontColor = .textRoyal
        dialogueText.zPosition = ZPositionsCategories.dialogueItems
        dialogueText.position = CGPoint(x: dialogueAnchor.x + 108, y: dialogueAnchor.y - 40)
        dialogueText.numberOfLines = 2
        addChild(dialogueText)
        
        // adiciona botão para avançar para o próximo diálogo
        dialogueButton = DefaultObject(name: "play-dialogue")
        if let spriteComponent = dialogueButton.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: dialogueAnchor.x + 380, y: dialogueAnchor.y - 45)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
//            let pulsed = SKAction.sequence([
//                SKAction.resize(byWidth: 10, height: 10, duration: 0.5),
//                SKAction.resize(byWidth: -10, height: -10, duration: 0.5)])
//            spriteComponent.node.run(SKAction.repeatForever(pulsed))
        }
        entityManager.add(dialogueButton)
        
        // adiciona botão para avançar para o próximo diálogo
                dialogueSkip = DefaultObject(name: "skip-button")
                if let spriteComponent = dialogueSkip.component(ofType: SpriteComponent.self) {
                    spriteComponent.node.position = CGPoint(x: dialogueAnchor.x + 378, y: dialogueAnchor.y - 125)
                    spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
                }
                entityManager.add(dialogueSkip)
    }
    
    func updateText () {
        if dialogueIndex < dialogues.count - 1 {
            dialogueIndex = dialogueIndex + 1
            dialogueText.text = dialogues[dialogueIndex]
        } else {
            skipText()
        }
    }
    
    func hintStage () {
        dialogueIndex = 0
        entityManager.add(dialogueBackground)
        entityManager.add(dialogueButton)
        entityManager.add(beep)
        entityManager.add(dialogueTab)
        entityManager.add(dialogueSkip)
        dialogueText.text = dialogues[dialogueIndex]
        addChild(dialogueText)
    }
    
    func skipText () {
        entityManager.remove(dialogueBackground)
        entityManager.remove(dialogueButton)
        entityManager.remove(beep)
        entityManager.remove(dialogueTab)
        entityManager.remove(dialogueSkip)
        dialogueText.removeFromParent()
        
    }
}
