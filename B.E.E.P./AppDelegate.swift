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
            api.designApi { (result) in
                switch result{
                case .success(let apiDesign):
                    print(apiDesign)
                    
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

