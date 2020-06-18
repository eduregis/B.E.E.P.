//
//  StageModel.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 18/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//
import Foundation

class StageModel: NSObject, NSCoding {
    
    var atualFase:Int
    var status:String
    let stageData:StageDesignModel

    init(atualFase: Int, status: String, stageData: StageDesignModel) {
        self.atualFase = atualFase
        self.status = status
        self.stageData = stageData
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.stageData, forKey: "stageData")
        coder.encode(self.status, forKey: "status")
        coder.encode(self.atualFase, forKey: "atualFase")
    }

    required init(coder: NSCoder) {
        self.stageData = coder.decodeObject(forKey: "stageData") as! StageDesignModel
        self.status = coder.decodeObject(forKey: "status") as! String
        self.atualFase = coder.decodeInteger(forKey: "atualFase")

    }

}



