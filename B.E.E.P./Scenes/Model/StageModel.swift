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
    let stageData:StageDesignModel

    init(isAtualFase: Bool, status: String, stageData: StageDesignModel) {
        self.isAtualFase = isAtualFase
        self.status = status
        self.stageData = stageData
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.stageData, forKey: "stageData")
        coder.encode(self.status, forKey: "status")
        coder.encode(self.isAtualFase, forKey: "isAtualFase")
    }

    required init(coder: NSCoder) {
        self.stageData = coder.decodeObject(forKey: "stageData") as! StageDesignModel
        self.status = coder.decodeObject(forKey: "status") as! String
        self.isAtualFase = coder.decodeBool(forKey: "isAtualFase")

    }

}



