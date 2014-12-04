//
//  Importer.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import CoreData

class Importer {
    private let context: NSManagedObjectContext

    init(context:NSManagedObjectContext) {
        self.context = context
    }

    func importPodSpecs(jsonSpecs: [NSDictionary]) {
        let names = jsonSpecs.map { $0["name"] }
        var existingSpecsRequest = NSFetchRequest(entityName: "PodSpec")
        existingSpecsRequest.predicate = NSPredicate(format: "name IN \(names)")
        var possibleError: NSError?
        let result = context.executeFetchRequest(existingSpecsRequest, error: &possibleError)
        if let error = possibleError {
            return // + log
        }

    }
}
