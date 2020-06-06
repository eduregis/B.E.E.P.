//
//  GameViewController.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 06/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsNodeCount = true
        }    }
}
