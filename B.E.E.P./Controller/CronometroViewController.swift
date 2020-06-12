//
//  CronometroViewController.swift
//  B.E.E.P.
//
//  Created by samuel sales on 11/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit


class CronometroViewController: UIViewController {

    var time = 0
    var timer = Timer()
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CronometroViewController.action), userInfo: nil, repeats: true)
    }
    @objc func action(){
        time+=1
    }
    func reset(){
        timer.invalidate()
        time = 0
    }
    override func loadView() {
         print("CronometroViewController")
        _ = Cronometro()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
