//
//  FetchedResultsControllerDataSource.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 09/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsControllerDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    let fetchedResultsController: NSFetchedResultsController
    // to keep strong reference
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultsController.delegate = fetchedResultsControllerDelegate
        }
    }
    private let reuseIdentifier: String

    init(fetchedResultsController: NSFetchedResultsController, reuseIdentifier: String) {
        self.fetchedResultsController = fetchedResultsController
        self.reuseIdentifier = reuseIdentifier
    }

    // MARK: - data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo
        return section?.numberOfObjects ?? 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    // TODO: make it generic
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = objectAtIndexPath(indexPath) as Pod
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = object.version
        return cell
    }

    // TODO: make it generic
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return fetchedResultsController.objectAtIndexPath(indexPath)
    }

//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//
//        }
//    }
}
