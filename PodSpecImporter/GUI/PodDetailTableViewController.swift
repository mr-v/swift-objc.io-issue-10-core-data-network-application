//
//  PodDetailTableViewController.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 09/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PodDetailTableViewController: UITableViewController {
    var pod: Pod!

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = pod.name
        versionLabel.text = pod.version
        authorsLabel.text = pod.authors
        homepageLabel.text = pod.homepage
        sourceLabel.text = pod.source
    }
}
