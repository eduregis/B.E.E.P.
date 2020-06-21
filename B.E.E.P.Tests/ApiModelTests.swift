//
//  ApiModelTests.swift
//  B.E.E.P.Tests
//
//  Created by Nathália Cardoso on 15/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import XCTest

@testable import B_E_E_P_

class ApiModelTests: XCTestCase {
    
    func test_apiModel_dialoguesModel() {
        XCTAssertNoThrow(DialoguesModel(name: "teste", text: ["teste"]))
    }
    
    func test_apiModel_stageDesignModel() {
        XCTAssertNoThrow(StageDesignModel(number: 0, width: 0, height: 0, tabStyle: "", initialDirection: "", initialPosition: [0], boxes: [0], dropZones: [0], infectedRobots: [0]))
        
    }
    
    func test_apiManager_callDesignApi_designFase() {
        //given
        let sut = ApiManager()
        
        //then
        XCTAssertNoThrow(sut.designApi(completion: { (result) in
        }))
    }
    
    func teste_apiManager_callDialoguesApi_dialogues() {
        //given
        let sut = ApiManager()
        
        //then
        XCTAssertNoThrow(sut.dialoguesApi(completion: { (result) in
        }))
    }
}
