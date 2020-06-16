//
//  ApiError.swift
//  B.E.E.P.
//
//  Created by Patricia Sampaio on 14/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case invalidUrl
    case couldNotDecode
    case failedRequest
    case unknowEroor (statuscode: Int)
}

