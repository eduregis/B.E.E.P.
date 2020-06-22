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

    override func loadView() {
        let view = SKView(frame: UIScreen.main.bounds) //cria uma sk view
        
        let scene = GameScene(size: view.bounds.size) //cria a scene que vai ser apresentada
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
        self.view = view
        
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    }
}
