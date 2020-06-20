//
//  BaseOfDialogues.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 20/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

class BaseOfDialogues {
    
    static func salvar(dialogue: DialoguesModel) {
        let data:Data = NSKeyedArchiver.archivedData(withRootObject: dialogue)
        
        UserDefaults.standard.set(data, forKey: dialogue.name)
    }
    
    static func buscar(id:String) -> DialoguesModel? {
        if let salvo:Data = UserDefaults.standard.object(forKey: id) as? Data {
            if let dialogue = NSKeyedUnarchiver.unarchiveObject(with: salvo) as? DialoguesModel {
                return dialogue
            }
        }
        return nil
    }
}
