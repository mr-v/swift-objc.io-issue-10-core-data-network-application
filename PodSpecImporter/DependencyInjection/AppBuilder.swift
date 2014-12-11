//
//  AppBuilder.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 09/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import CoreData
import UIKit

class AppBuilder : UIStoryboardInjector {
    let persistenceStack: PersistenceStack
    let importer: Importer
    // table view's data source is unowned(unsafe) so we need to hold on to it strongly here
    lazy var allPodsDataSource: FetchedResultsControllerDataSource = {
        var controller:NSFetchedResultsController  = self.allPodsFetchedResultsController()
        return FetchedResultsControllerDataSource(fetchedResultsController: controller, reuseIdentifier: "Cell")
    }()

    override init() {
        let documentsDirectory = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        let storeURL = documentsDirectory!.URLByAppendingPathComponent("db.sqlite")
        let modelURL = NSBundle.mainBundle().URLForResource("PodSpecModel", withExtension: "momd")!
        persistenceStack = PersistenceStack(modelURL: modelURL, storeURL: storeURL)
        importer = Importer(context: persistenceStack.backgroundContext)
        super.init()

        setupViewControllerDependencies()
    }

    func initializeStoryboard() -> UIStoryboard {
        return UIStoryboard.makeInjectableStoryboard(self)
    }

    private func setupViewControllerDependencies() {
        // TODO: add SBConstant?
        controllerDependencies["PodList"] = { [unowned self] vc in
            let listViewController = vc as PodListViewController
            listViewController.viewDidLoadHandler = {
                let dataSource: FetchedResultsControllerDataSource = self.allPodsDataSource
                let delegate = TableViewFetchedResultsControllerDelegate(tableView: listViewController.tableView)
                dataSource.fetchedResultsControllerDelegate = delegate
                listViewController.dataSource = dataSource

                dataSource.fetchedResultsController.performFetch(nil)
                UpdatePodsUseCase(importer: self.importer).execute()
                listViewController.viewDidLoadHandler = nil
            }
        }
    }

    private func allPodsFetchedResultsController() -> NSFetchedResultsController {
        var allPodsRequest = NSFetchRequest(entityName: "Pod")
        allPodsRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "version", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: allPodsRequest, managedObjectContext: persistenceStack.context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
}
