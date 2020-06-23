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
    static let background:         CGFloat = 0
    static let tab:                CGFloat = 1
    static let subTab:             CGFloat = 2
    static let dropZone:           CGFloat = 3
    static let button:             CGFloat = 4
    static let subDropZone:        CGFloat = 5
    static let clearTabButton:     CGFloat = 6
    static let configOptions:      CGFloat = 7
    static let emptyBlock:         CGFloat = 15
    static let draggableBlock:     CGFloat = 20
    static let unavailableStage:   CGFloat = 46
    static let mapLightFloor:      CGFloat = 47
    static let mapRobot:           CGFloat = 48
    static let dialogueBackground: CGFloat = 50
    static let dialogueTab:        CGFloat = 51
    static let dialogueItems:      CGFloat = 52
}

// cores
extension UIColor {
    static var textRoyal: UIColor { return UIColor(red: 41/255, green: 27/255, blue: 95/255, alpha: 1.0)
    }
}

enum Direction {
    case backward
    case forward
}

