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
    
//    init(json: [Any : Any]) {
//        self.name = json["name"] as? String? ?? ""
//        self.text = json["text"] as? [String]? ?? []
//    }
    
    
}

struct StageDesignModel: Codable {
    let number: Int
    let width: Int
    let height: Int
    let tabStyle: String
    let initialDirection: String
    let initialPosition: [Int]
    let boxes: [Int]
    let dropZones: [Int]
    let infectedRobots: [Int]
    
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


