//
//  Pod.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import CoreData

class Pod: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var summary: String

}
