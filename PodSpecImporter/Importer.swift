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

    func importPodSpecs(JSONSpecs: [NSDictionary]) {
        let namesToImport = JSONSpecs.map{ $0["name"] }
        var existingSpecsRequest = NSFetchRequest(entityName: "Pod")
        existingSpecsRequest.predicate = NSPredicate(format: "name IN \(namesToImport)")
        var possibleError: NSError?
        let result = context.executeFetchRequest(existingSpecsRequest, error: &possibleError) as [Pod]
        if let error = possibleError {
            return // + log
        }
        var existingPods = [String: Pod]()
        for pod in result { existingPods[pod.name] = pod }
        for data in JSONSpecs {
            var existing = existingPods[data["name"] as String]
            var pod = existing ?? NSEntityDescription.insertNewObjectForEntityForName("Pod", inManagedObjectContext: context) as Pod
            pod.loadFromJSONObject(data)
        }
    }
}
