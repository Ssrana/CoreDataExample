//
//  Preferences+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Sanchika on 31/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import CoreData


extension Preferences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preferences> {
        return NSFetchRequest<Preferences>(entityName: "Preferences")
    }

    @NSManaged public var sortedBy: String?

}
