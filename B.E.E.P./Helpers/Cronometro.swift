//
//  cronometro.swift
//  B.E.E.P.
//
//  Created by samuel sales on 11/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation
class Cronometro {
    var time = 0
    var timer = Timer()
    
    func start(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Cronometro.action), userInfo: nil, repeats: true)
    }
    @objc func action(){
        time+=1
        print(time)
        if time == 3 {
            timer.invalidate()
            time = -1
        }
    }
    func reset(){
        timer.invalidate()
        time = 0
    }
    init() {
        
    }
}
