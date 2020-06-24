//
//  ApiManager.swift
//  B.E.E.P.
//
//  Created by Patricia Sampaio on 14/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

struct ApiManager: Codable {

func dialoguesApi(completion: @escaping (Result< [DialoguesModel], ApiError>)-> Void) {
     
    var getComponents = URLComponents()
    getComponents.scheme = "https"
    getComponents.host = "dialogues-beep.herokuapp.com"
    getComponents.path = "/dialogues"
 
    guard let getUrl = getComponents.url else {
        completion(.failure(ApiError.invalidUrl))
        return
    }
    
    let session = URLSession(configuration: .default)
    
    let getDiologuesTask = session.dataTask(with: getUrl) { (data, response, error) in
        
        if error != nil {
            completion(.failure(ApiError.couldNotDecode))
        }
        
        guard let response = response as? HTTPURLResponse else {return}
        switch response.statusCode {
        case 200:
            if let data = data {
                if let dialoguesList = try? JSONDecoder().decode([DialoguesModel].self, from: data) {
                    completion(.success(dialoguesList))
                    UserDefaults.standard.set(true, forKey: "showDialogues")
                    print(dialoguesList.description)
                } else {
                    completion(.failure(ApiError.couldNotDecode))
                }
            }
        default:
            completion(.failure(ApiError.failedRequest))
        }
  }
        getDiologuesTask.resume()
}

func designApi(completion: @escaping (Result< [StageDesignModel], ApiError>)-> Void) {
     
    var getComponents = URLComponents()
    getComponents.scheme = "https"
    getComponents.host = "design-beep.herokuapp.com"
    getComponents.path = "/stageDesign"
 
    guard let getUrl = getComponents.url else {
        completion(.failure(ApiError.invalidUrl))
        return
    }
    
    let session = URLSession(configuration: .default)
    
    let getDesignTask = session.dataTask(with: getUrl) { (data, response, error) in
        
        if error != nil {
            completion(.failure(ApiError.couldNotDecode))
        }
        
        guard let response = response as? HTTPURLResponse else {return}
        switch response.statusCode {
        case 200:
            if let data = data {
                if let designList = try? JSONDecoder().decode([StageDesignModel].self, from: data) {
                    completion(.success(designList))
                    print(designList.description)
                    UserDefaults.standard.set(true, forKey: "buildMap")
                } else {
                    completion(.failure(ApiError.couldNotDecode))
                }
            }
        default:
            completion(.failure(ApiError.failedRequest))
        }
  }
        getDesignTask.resume()
}
 
}



