//
//  Result.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

enum Result<T> {
    case OK(T)
    case Error
}

// add name and description to Error - as of now adding non-generic associated values causes compiler to crash (note: works well in playgrounds)
