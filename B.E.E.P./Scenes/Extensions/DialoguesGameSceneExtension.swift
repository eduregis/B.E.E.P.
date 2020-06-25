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
        dialogueBackground = SKSpriteNode(imageNamed: "dialogue-background")
        dialogueBackground.name = "dialogue-background"
        dialogueBackground.size = CGSize(width: frame.width, height: frame.height)
        dialogueBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        dialogueBackground.zPosition = ZPositionsCategories.dialogueBackground
        dialogueBackground.alpha = 0
        dialogueBackground.run(SKAction.fadeAlpha(to: 0.6, duration: animateDuration))
        addChild(dialogueBackground)
        
        // adicionando B.E.E.P.
        
        if won {
            beep = SKSpriteNode(imageNamed: "beep-2")
        } else {
            beep = SKSpriteNode(imageNamed: "beep-1")
        }
        
        beep.name = "beep"
        beep.size = CGSize(width: 256, height: 256)
        beep.position = CGPoint(x: frame.midX/3 - CGFloat(animateVector)-15, y: frame.minY + beep.size.height/2)
        beep.zPosition = ZPositionsCategories.dialogueItems
        beep.alpha = 0
        let fadeToLeft = SKAction.group([
            SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
            SKAction.fadeAlpha(to: 1, duration: 0.5)])
        beep.run(fadeToLeft)
        addChild(beep)
        
        // adicionando caixa de diálogo
        dialogueTab = SKSpriteNode(imageNamed: "beep-dialogue")
        dialogueTab.name = "beep-dialogue"
        dialogueTab.position = CGPoint(x: dialogueAnchor.x + 128 + CGFloat(animateVector), y: dialogueAnchor.y)
        dialogueTab.zPosition = ZPositionsCategories.dialogueTab
        dialogueTab.alpha = 0
        let fadeToRight = SKAction.group([
            SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
            SKAction.fadeAlpha(to: 1, duration: 0.5)])
        dialogueTab.run(fadeToRight)
        addChild(dialogueTab)
        
        if !won {
            dialogueText = SKLabelNode(text: dialogues[dialogueIndex])
            dialogueText.fontSize = 14.0
        } else{
            //modelo de atualização dos dados do banco //ta feio mas é o que tem pra agora
            let faseAtual = UserDefaults.standard.object(forKey: "selectedFase")
            let stageOptional = BaseOfStages.buscar(id: "\(faseAtual!)")
            let nextStageOptional = BaseOfStages.buscar(id: "\(faseAtual as! Int + 1)")
            
            
            guard let stage = stageOptional else { return  }
            
            //gambiarra por causa do bug quando repete de fase
            for i in 1...6 {
                let stage = BaseOfStages.buscar(id: "\(i)")
                stage?.isAtualFase = false
                BaseOfStages.salvar(stage: stage!)
            }
            //fim da gambiarra
            
            if let nextStage = nextStageOptional {
                UserDefaults.standard.set(nextStage.number, forKey: "selectedFase")
                nextStage.status = "available"
                nextStage.isAtualFase = true
                //lastStageAvailable = nextStage.number
                UserDefaults.standard.set(true, forKey: "newStageAvailable")
                BaseOfStages.salvar(stage: nextStage)
            } else {
                stage.isAtualFase = true
                BaseOfStages.salvar(stage: stage)
            }
            //fim do modelo
            let user = UserDefaults.standard.object(forKey: "userGame")
            dialogueText = SKLabelNode(text: "Perfeito \(user ?? "")! Sabia que  podia contar com você!")
            dialogueText.fontSize = 14.0
        }
        dialogueText.fontName = "8bitoperator"
        dialogueText.fontColor = .textRoyal
        dialogueText.zPosition = ZPositionsCategories.dialogueItems
        dialogueText.position = CGPoint(x: dialogueAnchor.x - 138 + CGFloat(animateVector), y: dialogueAnchor.y + 20)
        dialogueText.verticalAlignmentMode = .top
        dialogueText.horizontalAlignmentMode = .left
        dialogueText.numberOfLines = 2
        dialogueText.alpha = 0
        dialogueText.run(fadeToRight)
        addChild(dialogueText)
        
        
        let namePlay: String
        if won {
            namePlay = "next-button"
        }else{
            namePlay = "play-dialogue"
        }
        // adiciona botão para avançar para o próximo diálogo
        dialogueButton = SKSpriteNode(imageNamed: "play-dialogue")
        dialogueButton.name = namePlay
        dialogueButton.position = CGPoint(x: dialogueAnchor.x + 380 + CGFloat(animateVector), y: dialogueAnchor.y - 45)
        dialogueButton.zPosition = ZPositionsCategories.dialogueItems
        dialogueButton.alpha = 0
        dialogueButton.run(fadeToRight)
        addChild(dialogueButton)
        
        // adiciona botão para avançar para o próximo diálogo
        
        if !won {
            dialogueSkip = SKSpriteNode(imageNamed: "skip-button")
            dialogueSkip.name = "skip-button"
            dialogueSkip.position = CGPoint(x: dialogueAnchor.x + 378 + CGFloat(animateVector), y: dialogueAnchor.y - 125)
            dialogueSkip.zPosition = ZPositionsCategories.dialogueItems
            dialogueSkip.alpha = 0
            dialogueSkip.run(fadeToRight)
            addChild(dialogueSkip)
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
        let faseAtual = UserDefaults.standard.object(forKey: "selectedFase")
        
        let dialoguesOpt = BaseOfDialogues.buscar(id: "stage-\(faseAtual!)")
        
        guard let dialogues = dialoguesOpt else { return  }
        
        self.dialogues = dialogues.text
        drawDialogues(won: false)
    }
    
    func skipText (next: Bool) {
        
        
        let animateDuration = 0.3
        let animateVector = 50
        
        dialogueBackground.run(SKAction.fadeAlpha(to: 0, duration: animateDuration)) {
            self.dialogueBackground.removeFromParent()
        }
        
        let backToLeft = SKAction.group([
            SKAction.move(by: CGVector(dx: -animateVector, dy: 0), duration: animateDuration),
            SKAction.fadeAlpha(to: 0, duration: animateDuration)])
        beep.run(backToLeft) {
            self.beep.removeFromParent()
        }
        
        let backToRight = SKAction.group([
            SKAction.move(by: CGVector(dx: animateVector, dy: 0), duration: animateDuration),
            SKAction.fadeAlpha(to: 0, duration: animateDuration)])
        dialogueButton.run(backToRight) {
            self.dialogueButton.removeFromParent()
        }
        
        dialogueTab.run(backToRight) {
            self.dialogueTab.removeFromParent()
        }
        
        
        dialogueSkip.run(backToRight) {
            self.dialogueSkip.removeFromParent()
        }
        
        dialogueText.run(backToRight) {
            self.dialogueText.removeFromParent()
            
            if next {
                self.returnToMap()
            }
        }
    }
}
