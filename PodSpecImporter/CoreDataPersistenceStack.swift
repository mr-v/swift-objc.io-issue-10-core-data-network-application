//
//  CoreDataPersistenceStack.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 05/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import CoreData

class PersistenceStack {
    private let context: NSManagedObjectContext!
    let backgroundContext: NSManagedObjectContext!

    init(modelURL: NSURL, storeURL: NSURL) {
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!
        context = setupContextWithConcurrencyType(.MainQueueConcurrencyType, model: model, storeURL: storeURL)
        backgroundContext = setupContextWithConcurrencyType(.PrivateQueueConcurrencyType, model: model, storeURL: storeURL)

        NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) {
            [weak self] notification in
            if let context = self?.context {
                if context != notification.object as? NSManagedObjectContext {
                    context.performBlock { context.mergeChangesFromContextDidSaveNotification(notification) }
                }
            }
        }
    }

    private func setupContextWithConcurrencyType(type: NSManagedObjectContextConcurrencyType, model: NSManagedObjectModel, storeURL: NSURL) -> NSManagedObjectContext {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        var possibleError: NSError?
        coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &possibleError)
        if let error = possibleError {
            abort()
        }
        var context = NSManagedObjectContext(concurrencyType: type)
        context.persistentStoreCoordinator = coordinator
        return context
    }
}