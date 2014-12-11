//
//  TableViewFetchedResultsControllerDelegate.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 09/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import CoreData

class TableViewFetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate {
    private let tableView: UITableView

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            if contains(tableView.indexPathsForVisibleRows() as [NSIndexPath], indexPath!) {
                tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            }
        }
    }
}
