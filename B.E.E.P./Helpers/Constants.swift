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


enum ZPositionsCategories {
    static let background:     CGFloat = 0
    static let tab:            CGFloat = 1
    static let subTab:         CGFloat = 2
    static let dropZone:       CGFloat = 3
    static let button:         CGFloat = 4
    static let subDropZone:    CGFloat = 5
    static let clearTabButton: CGFloat = 6
    static let emptyBlock:     CGFloat = 15
    static let draggableBlock: CGFloat = 20
}

enum Direction {
    case backward
    case forward
}

