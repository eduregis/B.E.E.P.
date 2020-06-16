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
        // adicionando fundo escuro
        dialogueBackground = DefaultObject(name: "dialogue-background", spriteName: "dialogue-background", size: CGSize(width: frame.width, height: frame.height))
        if let spriteComponent = dialogueBackground.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX, y: frame.midY)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueBackground
            spriteComponent.node.alpha = 0.6
        }
        entityManager.add(dialogueBackground)
        
        // adicionando B.E.E.P.
        dialogueBackground = DefaultObject(name: "beep", spriteName: "beep-1", size: CGSize(width: 256, height: 256))
        if let spriteComponent = dialogueBackground.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX/3, y: frame.minY + spriteComponent.node.size.height/2)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueItems
        }
        entityManager.add(dialogueBackground)
        
        // adicionando caixa de diálogo
        dialogueBackground = DefaultObject(name: "beep-dialogue", spriteName: "beep-dialogue")
        if let spriteComponent = dialogueBackground.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: frame.midX + 128, y: frame.midY/3)
            spriteComponent.node.zPosition = ZPositionsCategories.dialogueTab
        }
        entityManager.add(dialogueBackground)
        
        dialogueText = SKLabelNode(text: dialogues[0])
        dialogueText.fontName = "8bitoperator"
        dialogueText.fontSize = 14.0
        dialogueText.fontColor = .magenta
        dialogueText.zPosition = ZPositionsCategories.dialogueItems
        dialogueText.position = CGPoint(x: frame.midX + 128, y: frame.midY/3)
        dialogueText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        dialogueText.numberOfLines = 2
        addChild(dialogueText)
    }
}
