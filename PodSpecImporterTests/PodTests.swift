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

    func test_loadFromJSONObject_ExtractsIdentifier() {
        var pod: Pod! = makePodWithTestData()

        XCTAssertEqual("AFNetworking 2.5.0", pod.identifier)
    }

    func test_loadFromJSONObject_ExtractsName() {
        var pod: Pod! = makePodWithTestData()

        XCTAssertEqual("AFNetworking", pod.name)
    }

    func test_loadFromJSONObject_ExtractsVersion() {
        var pod: Pod! = makePodWithTestData()

        XCTAssertEqual("2.5.0", pod.version)
    }

    func test_loadFromJSONObject_ExtractsAuthors() {
        var pod: Pod! = makePodWithTestData()

        XCTAssertEqual("Mattt Thompson", pod.authors)
    }

    func test_loadFromJSONObject_ExtractsHomepage() {
        var pod: Pod! = makePodWithTestData()

        XCTAssertEqual("https://github.com/AFNetworking/AFNetworking", pod.homepage)
    }

    func test_loadFromJSONObject_ExtractsSource() {
        var pod: Pod! = makePodWithTestData()

        XCTAssertEqual("https://github.com/AFNetworking/AFNetworking.git", pod.source)
    }

    // MARK: -

    private func makePodWithTestData() -> Pod? {
        var pod = makePod()
        pod?.loadFromJSONObject(makeTestPodSpecJSONObject())
        return pod
    }

    private func makePod() -> Pod? {
        let model = makeCoreDataModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        var possibleError: NSError?
        coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: &possibleError)
        if let error = possibleError {
            println(error)
            abort()
        }

        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = coordinator

        let podDescription = NSEntityDescription.entityForName("Pod", inManagedObjectContext: context)
        return Pod(entity: podDescription!, insertIntoManagedObjectContext: context)
    }

    private func makeCoreDataModel() -> NSManagedObjectModel {
        let modelURL = NSBundle.mainBundle().URLForResource("PodSpecModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!

        // alternative when not setting prefix for module
        // http://stackoverflow.com/questions/25076276/unabled-to-find-specific-subclass-of-nsmanagedobject
        /*
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
        */
    }

    private func makeTestPodSpecJSONObject() -> NSDictionary {
        return [
            "name": "AFNetworking",
            "version": "2.5.0",
            "homepage": "https://github.com/AFNetworking/AFNetworking",
            "social_media_url": "https://twitter.com/AFNetworking",
            "authors": [
                "Mattt Thompson": "m@mattt.me"
            ],
            "source": [
                "git": "https://github.com/AFNetworking/AFNetworking.git",
                "tag": "2.5.0",
                "submodules": true
            ]
        ]
    }
}

