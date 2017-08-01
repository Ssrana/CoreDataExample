//
//  HDMainTableHeaderView.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

class HDMainTableHeaderView: UIView {

    @IBOutlet weak var totalEmployeesHeaderLabel: UILabel!
    @IBOutlet weak var employeeCount: UILabel!
    @IBOutlet weak var todaysReport: UILabel!
    @IBOutlet weak var sortByButton: UIButton!
    let alertOptions = ["Name", "Date of birth", "Designation"]
	weak var parentVC:HDMainViewController?

    @IBAction func sortByButtonAction(_ sender: Any) {
        let title = "Sort"
        let message = "Sort employees by"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        for alertTitle in alertOptions {
            alert.addAction(UIAlertAction(title: alertTitle, style: UIAlertActionStyle.default, handler: myHandler))
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        parentVC!.present(alert, animated: true, completion: nil)
    }

    
    func myHandler(alert: UIAlertAction)
    {
        HDPreferencesData.sharedInstance.updatePreferences(SortedBy: alert.title!.lowercased())
        parentVC?.updatedEmployee()
        setDetailsForSortByValue()
    }    
    
    static func createView() -> HDMainTableHeaderView {
        return Bundle.main.loadNibNamed("HDMainTableHeaderView", owner: nil, options: nil)?.first as! HDMainTableHeaderView
    }
    
	final func setUserInterFace(employee:[Employee]) {
		self.employeeCount.text = "\(employee.count)"
		var calendar = NSCalendar.current
		calendar.timeZone = NSTimeZone.local
		var count = 0
		for obj in employee {
			if obj.dateAdded!.isDateInToday() == true {
				count = count + 1
			}
		}
		self.todaysReport.text = "Todays Report: " + "\(count)"
        setDetailsForSortByValue()
	}
    
    func setDetailsForSortByValue() {
        let preferencesValue =  HDPreferencesData.sharedInstance.preferences[0].sortedBy!
        let title = "Sort by: " + preferencesValue.capitalized
        self.sortByButton.setTitle(title, for: .normal)
    }
}
