//
//  LightFloorTests.swift
//  B.E.E.P.Tests
//
//  Created by Nathália Cardoso on 15/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import XCTest

@testable import B_E_E_P_

class LightFloorTests: XCTestCase {
    
    func test_lightFloor_lightFloorMove_movement() {
        //given
        let sut = LightFloorMoveComponent()
        let input1 = "left"
        
        //when
        let output1 = sut.move(direction: input1)
        
        //then
        XCTAssertNoThrow(output1)
    }
}
