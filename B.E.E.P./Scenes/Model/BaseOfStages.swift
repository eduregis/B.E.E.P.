//
//  BaseOfStages.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 18/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

class BaseOfStages {
    
    static func salvar(stage: StageModel) {
        let data:Data = NSKeyedArchiver.archivedData(withRootObject: stage)
        
        UserDefaults.standard.set(data, forKey: "\(stage.stageData.number)")
    }
    
    static func buscar(id: String) -> StageDesignModel? {
        
        if let salvo:Data = UserDefaults.standard.object(forKey: id) as? Data {
            if let stage = NSKeyedUnarchiver.unarchiveObject(with: salvo) as? StageDesignModel {
                return stage
            }
        }
        
        return nil
    }
}
