//
//  GameViewControllerTests.swift
//  B.E.E.P.Tests
//
//  Created by Nathália Cardoso on 15/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import XCTest

@testable import B_E_E_P_

class GameViewControllerTests: XCTestCase {
    
    func test_GameViewController_loadView() {
        //given
        let sut = GameViewController()
        
        //then
        XCTAssertNoThrow(sut.loadView())
    }
    
    func test_GameViewController_viewDidLoad() {
        //given
        let sut = GameViewController()
        
        //then
        XCTAssertNoThrow(sut.viewDidLoad())
    }
}
