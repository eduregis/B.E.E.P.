//
//  SoundsExtension.swift
//  B.E.E.P.
//
//  Created by samuel sales on 20/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

extension GameScene {
    func startBackgroundSound() {
        backgroundSound.isPositional = false
        addChild(backgroundSound)
        
        do {
            try backgroundSound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
    }
    func pauseBackgroundSound(){
        backgroundSound.removeFromParent()
    }
    func startMoveSound() {
        let sound = SKAudioNode(fileNamed: "robot-move")
        addChild(sound)
        do {
            try sound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
       if let pause = robot.component(ofType: SpriteComponent.self){
            pause.node.run(SKAction.wait(forDuration: 0.1)){
                //sound.avAudioNode?.engine?.pause()
                sound.removeFromParent()
            }
        }
    }
    func startPlaySound() {
        let sound = SKAudioNode(fileNamed: "play-command-tab")
        
        addChild(sound)
        do {
            try sound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
       if let pause = robot.component(ofType: SpriteComponent.self){
            pause.node.run(SKAction.wait(forDuration: 0.3)){
                //sound.avAudioNode?.engine?.pause()
                sound.removeFromParent()
            }
        }
        
    }
    func startDropBoxSound() {
        let sound = SKAudioNode(fileNamed: "drop-box-in-zone")
        
        addChild(sound)
        do {
            try sound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
       if let pause = robot.component(ofType: SpriteComponent.self){
            pause.node.run(SKAction.wait(forDuration: 0.3)){
                //sound.avAudioNode?.engine?.pause()
                sound.removeFromParent()
            }
        }
        
    }
    
    func startSaveSound() {
        let sound = SKAudioNode(fileNamed: "save-infected")
        
        addChild(sound)
        do {
            try sound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
       if let pause = robot.component(ofType: SpriteComponent.self){
            pause.node.run(SKAction.wait(forDuration: 0.9)){
                //sound.avAudioNode?.engine?.pause()
                sound.removeFromParent()
            }
        }
    }
    
}
extension MapScene {
    func startBackgroundSound() {
        backgroundSound.isPositional = false
        addChild(backgroundSound)
        
        do {
            try backgroundSound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
    }
    func pauseBackgroundSound(){
        backgroundSound.removeFromParent()
    }
}

extension ConfigScene {
    func startBackgroundSound() {
        
        backgroundSound.isPositional = false
        addChild(backgroundSound)
        
        do {
            try backgroundSound.avAudioNode?.engine?.start() // Called when you want to play sound
        } catch {
            // Do something with the error
        }
    }
    func pauseBackgroundSound(){
        backgroundSound.removeFromParent()
    }
}
