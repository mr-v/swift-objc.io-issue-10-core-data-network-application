//
//  JSONInitializers.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

extension Pod {
    func loadFromJSONObject(JSONObject: NSDictionary) {
        let name = JSONObject["name"] as String
        let version = JSONObject["version"] as? String ?? ""
        identifier = name + " " + version
        self.name = name
        self.version = version
        homepage = JSONObject["homepage"] as String
        source = JSONObject["source"]!["git"] as? String ?? " " // TODO: handle "http" source

        switch JSONObject["authors"] {
        case let dict as[String: String]:
            authors = ", ".join(dict.keys)
        case let array as [String]:
            authors = ", ".join(array)
        default:
            authors = ""
        }
    }
}
