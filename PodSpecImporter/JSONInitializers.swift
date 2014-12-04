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
        let version = JSONObject["version"] as String
        self.name = name + " " + version
        summary = JSONObject["summary"] as String
    }
}
