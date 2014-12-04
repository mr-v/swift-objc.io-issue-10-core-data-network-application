//
//  PodTests.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest
import CoreData

class PodTests: XCTestCase {
    var context: NSManagedObjectContext!

    func test_loadFromJSONObject_ExtractsName() {
        var pod = makePod()

        pod.loadFromJSONObject(makeTestPodSpecJSONObject())

        XCTFail()
    }


    // MARK: -

    private func makeTestPodSpecJSONObject() -> NSDictionary {
        return ["name": "Test PodSpec", "version": "1.0.1", "summary": "best summary ever"]
    }

    private func makePod() -> Pod {
        let model = makeCoreDataModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        var possibleError: NSError?
        coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: &possibleError)
        if let error = possibleError {
            println(error)
            assert(false)
        }

        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = coordinator

        let podDescription = NSEntityDescription.entityForName("Pod", inManagedObjectContext: context)
        return NSEntityDescription.insertNewObjectForEntityForName("Pod", inManagedObjectContext: context) as Pod
    }

    // http://stackoverflow.com/questions/25076276/unabled-to-find-specific-subclass-of-nsmanagedobject
    private func makeCoreDataModel() -> NSManagedObjectModel {
        let modelURL = NSBundle.mainBundle().URLForResource("PodSpecModel", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!

        // Check if we are running as test or not
        let environment = NSProcessInfo.processInfo().environment as [String : AnyObject]
        let pathExtension = environment["XCInjectBundle"]?.pathExtension
        let isTest = pathExtension == "xctest"

        // Create the module name
        let defaultModuleName = "PodSpecImporter"
        let moduleName = isTest ? defaultModuleName + "Tests" : defaultModuleName

        // Create a new managed object model with updated entity class names
        let newEntities: [NSEntityDescription] = model.entities.map {
            let entity = $0.copy() as NSEntityDescription
            entity.managedObjectClassName = "\(moduleName).\(entity.name!)"
            return entity
        }

        let newManagedObjectModel = NSManagedObjectModel()
        newManagedObjectModel.entities = newEntities        
        return newManagedObjectModel
    }
}