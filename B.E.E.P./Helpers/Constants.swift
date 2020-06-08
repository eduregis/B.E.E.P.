//
//  Constants.swift
//  B.E.E.P.
//
//  Created by Eduardo Oliveira on 06/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation
import SpriteKit

var blockTypes = ["walk-block","turn-left-block","turn-right-block","grab-block","save-block"]

enum PhysicsCategories {
    static let none: UInt32          = 0x1 << 0
    static let actionBlock: UInt32  = 0x1 << 1
    static let emptyBlock: UInt32 = 0x2 << 2
}
