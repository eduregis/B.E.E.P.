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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //inicio da configuração pra colocar a controller na tela (view code)
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let controller = MapViewController()
        window.rootViewController = controller
        
        self.window = window
        window.makeKeyAndVisible()
        // fim da configuração pra view code
        return true
        
    }

}

