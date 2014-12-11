//
//  DictionaryExtension.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

func + <K, V> (left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    var result = left
    for (k, v) in right {
        result.updateValue(v, forKey: k)
    }
    return result
}
