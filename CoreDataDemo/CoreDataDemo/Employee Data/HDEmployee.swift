//
//  HDEmployee.swift
//  CoreDataDemo
//
//  Created by Sanchika on 27/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class HDEmployee {
    
    static let sharedInstance = HDEmployee()
    
    var employees = [Employee]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContextOnAddEmployee() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

	func removeEmployee(employee:Employee) {
		self.context.delete(employee)
		(UIApplication.shared.delegate as! AppDelegate).saveContext()
	}
    
    func employeeData() -> [Employee] {
        
        do {
            employees = try context.fetch(Employee.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        
        return employees
    }
    
    func userSelectedContact(contactIdentifier: String)-> [Employee] {
        
        var results = [Employee]()
        do {
            let formatRequest:NSFetchRequest<Employee> = Employee.fetchRequest()
            formatRequest.predicate = NSPredicate(format: "name contains[c] %@", contactIdentifier)
            let fetchedResults = try context.fetch(formatRequest)
            for employee in fetchedResults {
                results.append(employee)
            }
        }
        catch {
            print ("fetch employee failed", error)
        }
        return results
        
    }
    
}
