//
//  StageModel.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 18/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//
import Foundation

class StageModel: NSObject, NSCoding {
    
    var isAtualFase:Bool
    var status:String
    let dropZones, infectedRobots: [Int]
    let initialDirection, tabStyle: String
    let boxes, initialPosition: [Int]
    let number, height, width: Int

    init(isAtualFase: Bool, status: String, number: Int, width: Int, height: Int, tabStyle: String, initialDirection: String, initialPosition: [Int], boxes: [Int], dropZones: [Int], infectedRobots: [Int]) {
    
        self.isAtualFase = isAtualFase
        self.status = status
        self.number = number
        self.width = width
        self.height = height
        self.tabStyle = tabStyle
        self.initialPosition = initialPosition
        self.initialDirection = initialDirection
        self.boxes = boxes
        self.dropZones = dropZones
        self.infectedRobots = infectedRobots
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.status, forKey: "status")
        coder.encode(self.isAtualFase, forKey: "isAtualFase")
        coder.encode(self.number, forKey: "number")
        coder.encode(self.width, forKey: "width")
        coder.encode(self.height, forKey: "height")
        coder.encode(self.tabStyle, forKey: "tabStyle")
        coder.encode(self.initialDirection, forKey: "initialDirection")
        coder.encode(self.initialPosition, forKey: "initialPosition")
        coder.encode(self.boxes, forKey: "boxes")
        coder.encode(self.dropZones, forKey:  "dropZones")
        coder.encode(self.infectedRobots, forKey: "infectedRobots")
    }

    required init(coder: NSCoder) {
        self.status = coder.decodeObject(forKey: "status") as! String
        self.isAtualFase = coder.decodeBool(forKey: "isAtualFase")
        self.number = coder.decodeInteger(forKey: "number")
        self.width = coder.decodeInteger(forKey: "width")
        self.height = coder.decodeInteger(forKey: "height")
        self.tabStyle = coder.decodeObject(forKey: "tabStyle") as! String
        self.initialPosition = coder.decodeObject(forKey: "initialPosition") as! [Int]
        self.initialDirection = coder.decodeObject(forKey: "initialDirection") as! String
        self.boxes = coder.decodeObject(forKey: "boxes") as! [Int]
        self.dropZones = coder.decodeObject(forKey: "dropZones") as! [Int]
        self.infectedRobots = coder.decodeObject(forKey: "infectedRobots") as! [Int]

    }

}



