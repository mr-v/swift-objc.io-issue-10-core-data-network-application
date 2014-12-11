//
//  PodSpecImporter.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 08/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import CoreData

class Pod: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var authors: String
    @NSManaged var source: String
    @NSManaged var version: String
    @NSManaged var homepage: String
    @NSManaged var identifier: String

}
