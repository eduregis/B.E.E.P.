//
//  RobotActionsTests.swift
//  B.E.E.P.Tests
//
//  Created by Nathália Cardoso on 15/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import XCTest

@testable import B_E_E_P_

class RobotActionsTests: XCTestCase {
    
    func test_conditional_objectAhead_containsObject() {
        //given
        let sut = GameScene()
        let input1 = "infected"
        
        //when
        let output1 = sut.objectAhead(type: input1)
        
        //then
        XCTAssertEqual(output1, false)
    }
    
    func test_conditional_cliffAhead_containsCliff() {
        //given
        let sut = GameScene()
        
        //when
        let output1 = sut.cliffAhead()
        
        //then
        XCTAssertEqual(output1, false)
    }
    
    func test_action_moveRobot_isPossible() {
        //given
        let sut = GameScene()
        
        //when
        let output1 = sut.moveRobot()
        
        //then
        XCTAssertEqual(output1, true)
    }
    
    func test_action_turnRobot_actionTurn() {
        //given
        let sut = GameScene()
        let input1 = "left"
        
        //when
        let output1 = sut.turnRobot(direction: input1)
        
        //then
        XCTAssertNoThrow(output1)
    }
}
