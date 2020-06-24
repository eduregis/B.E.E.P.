//
//  ApiModel.swift
//  B.E.E.P.
//
//  Created by Patricia Sampaio on 14/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

class DialoguesModel: NSObject, Codable, NSCoding {
    
    let name: String
    let text: [String]
    
    init (name: String, text: [String]){
        self.name = name
        self.text = text
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.text, forKey: "text")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.text = coder.decodeObject(forKey: "text") as! [String]
    }
    
}

struct StageDesignModel: Codable {
    let dropZones, infectedRobots: [[Int]]
    let initialDirection, tabStyle: String
    let infectedDirections: [String]
    let initialPosition: [Int]
    let boxes: [[Int]]
    let number, height, width: Int
    
    init(number: Int, width: Int, height: Int, tabStyle: String, initialDirection: String, initialPosition: [Int], boxes: [[Int]], dropZones: [[Int]], infectedRobots: [[Int]], infectedDirections: [String]){
        self.number = number
        self.width = width
        self.height = height
        self.tabStyle = tabStyle
        self.initialDirection = initialDirection
        self.initialPosition = initialPosition
        self.boxes = boxes
        self.dropZones = dropZones
        self.infectedRobots = infectedRobots
        self.infectedDirections = infectedDirections
    }
    
}
