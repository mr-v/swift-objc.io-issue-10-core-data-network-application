//
//  PodListViewController.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 09/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias OnViewDidLoadHandler = () -> ()
class PodListViewController: UITableViewController {
    var viewDidLoadHandler: OnViewDidLoadHandler!
    var dataSource: FetchedResultsControllerDataSource! {
        didSet {
            tableView.dataSource = dataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadHandler()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PodDetailSegue" {
            var detailController = segue.destinationViewController as PodDetailTableViewController
            if let selectedIndex = tableView.indexPathForSelectedRow() {
                let pod: Pod = dataSource.objectAtIndexPath(selectedIndex) as Pod
                detailController.pod = pod
            }
        }
    }
}
