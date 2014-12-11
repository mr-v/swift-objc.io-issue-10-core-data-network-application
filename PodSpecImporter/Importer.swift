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
        var namesToImport = NSMutableSet()
        for spec in JSONSpecs {
            let identifier = identifierFromData(spec)  // TOOD: add test for pod with name "CCNXML 0.2.1" (no "version" key)
            namesToImport.addObject(identifier)
        }
        var existingSpecsRequest = NSFetchRequest(entityName: "Pod")
        existingSpecsRequest.predicate = NSPredicate(format: "(identifier IN %@)", namesToImport)

        context.performBlock { [weak self] in
            if let context = self?.context {
                tryWithError { errorPointer in context.executeFetchRequest(existingSpecsRequest, error: errorPointer) as [Pod] }
                    .onSuccess { result in
                        var existingPods = [String: Pod]()
                        for pod in result { existingPods[pod.identifier] = pod }
                        for data in JSONSpecs {
                            let identifier: String! = self?.identifierFromData(data)
                            var existing = existingPods[identifier]
                            var pod = existing ?? NSEntityDescription.insertNewObjectForEntityForName("Pod", inManagedObjectContext: context) as Pod
                            pod.loadFromJSONObject(data)
                        }
                    }
                    .onError { println("error on pods fetch: \($0)") }
            }

        }
    }

    func save() {
        context.performBlock { [weak self] in self?.context.save(nil); return }
    }

    private func identifierFromData(data: NSDictionary) -> String {
        return " ".join([data["name"] as String, data["version"] as? String ?? " "])
    }
}
