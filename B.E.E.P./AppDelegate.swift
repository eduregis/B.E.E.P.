//
//  AppDelegate.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 06/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var api = ApiManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //inicio da configuração pra colocar a controller na tela (view code)
        
        if UserDefaults.standard.bool(forKey: "First Launch") == false {
            print("entrou aqui")
            //UserDefaults.standard.set(true, forKey: "isFirstTime")
            UserDefaults.standard.set(false, forKey: "buildMap")
            UserDefaults.standard.set(1, forKey: "selectedFase")
            UserDefaults.standard.set(false, forKey: "showDialogues")
            
            api.dialoguesApi { (result) in
                switch result {
                case .success(let apiDialogues):
                    for dialogue in apiDialogues {
                        let dialogue = DialoguesModel(name: dialogue.name, text: dialogue.text)
                        BaseOfDialogues.salvar(dialogue: dialogue)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            api.designApi { (result) in
                switch result{
                case .success(let apiDesign):
                    for fase in apiDesign {
                        if fase.number == 1 {
                            let stage = StageModel(isAtualFase: true, status: "available", number: fase.number, width: fase.width, height: fase.height, tabStyle: fase.tabStyle, initialDirection: fase.initialDirection, initialPosition: fase.initialPosition, boxes: fase.boxes, dropZones: fase.dropZones, infectedRobots: fase.infectedRobots,infectedDirections: fase.infectedDirections)
                            BaseOfStages.salvar(stage: stage)
                            
                        } else {
                            let stage = StageModel(isAtualFase: false, status: "unavailable", number: fase.number, width: fase.width, height: fase.height, tabStyle: fase.tabStyle, initialDirection: fase.initialDirection, initialPosition: fase.initialPosition, boxes: fase.boxes, dropZones: fase.dropZones, infectedRobots: fase.infectedRobots, infectedDirections: fase.infectedDirections)
                            BaseOfStages.salvar(stage: stage)
                        }
                    }
                    
                case .failure(let erro):
                    print(erro.localizedDescription)
                }
            }
        }
        UserDefaults.standard.set(true, forKey: "First Launch")
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let controller = MapViewController()
        window.rootViewController = controller
        
        self.window = window
        window.makeKeyAndVisible()
        // fim da configuração pra view code
        return true
        
    }

}

