//
//  Employee+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Sanchika on 31/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var address: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var designation: String?
    @NSManaged public var gender: String?
    @NSManaged public var hobbies: NSData?
    @NSManaged public var name: String?
    @NSManaged public var profilePic: Data?
    @NSManaged public var thumbnail: Data?

}
