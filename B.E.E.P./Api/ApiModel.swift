//
//  ApiModel.swift
//  B.E.E.P.
//
//  Created by Patricia Sampaio on 14/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

struct DialoguesModel: Codable {
    let name: String
    let text: [String]
    
    init (name: String, text: [String]){
        self.name = name
        self.text = text
    }
    
}

struct StageDesignModel: Codable {
    let dropZones, infectedRobots: [Int]
    let initialDirection, tabStyle: String
    let boxes, initialPosition: [Int]
    let number, height, width: Int
    
    init(number: Int, width: Int, height: Int, tabStyle: String, initialDirection: String, initialPosition: [Int], boxes: [Int], dropZones: [Int], infectedRobots: [Int]){
        self.number = number
        self.width = width
        self.height = height
        self.tabStyle = tabStyle
        self.initialDirection = initialDirection
        self.initialPosition = initialPosition
        self.boxes = boxes
        self.dropZones = dropZones
        self.infectedRobots = infectedRobots
    }
    
}
