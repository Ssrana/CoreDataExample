//
//  HDEmployeeData.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum EmployeeLaunchType {
    case createEmployee()
    case editEmployee()
}

final class HDEmployeeData {
    let employee:Employee?
    
    init(employee:Employee?) {
        self.employee = employee
    }
}

final class HDEmployeeDataHelper {
    var employeeData:HDEmployeeData?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // in future if other details are needed seperatly for create and edit, we can use two differnt function
    final func createEmployeeData(employee:Employee?) {
        employeeData = HDEmployeeData(employee: employee)
    }
    
    final func editEmployeeData(employee:Employee?) {
        employeeData = HDEmployeeData(employee: employee)
    }
}
