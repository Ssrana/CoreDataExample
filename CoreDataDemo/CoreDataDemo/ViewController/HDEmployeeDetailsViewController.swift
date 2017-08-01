//
//  HDEmployeeDetailsViewController.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

protocol HDEmployeeDetailsViewControllerDelagate: NSObjectProtocol {
	func updatedEmployee()
}

class HDEmployeeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HDAddEmployeeDetailsViewControllerDelegate {

	@IBOutlet weak var tableView: UITableView!

	weak var delegate:HDEmployeeDetailsViewControllerDelagate?
    var employee:Employee
	var dataSet = HDTableDataSet()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setBasicUI()
		self.updateTableView()
		self.setNavBarDetails()
    }

	final func setBasicUI() {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 70
		HDTwoLabelTableViewCell.registerCellForTableView(self.tableView, identifier: HDTwoLabelTypeCell)
		HDImageTableViewCell.registerCellForTableView(self.tableView, identifier: HDImageTypeCell)
	}

	final func setNavBarDetails() {
		let submitButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(HDEmployeeDetailsViewController.editDetailsAction(_:)))
		navigationItem.rightBarButtonItems = [submitButton]
		self.title = "Details"
	}

    init(employee:Employee) {
        self.employee = employee
        super.init(nibName: "HDEmployeeDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final func updateTableView() {
        let section0 = HDTableSection()
        let sections = NSMutableArray()
        
        let imageCellData = HDImageTableViewCellViewData()
        imageCellData.text1 = "Name"
        imageCellData.text2 = employee.name!
        imageCellData.imageData = employee.thumbnail!
        imageCellData.editButtonEnabled = false
        imageCellData.cellKind = HDCellKind.ImageNameType.rawValue
        imageCellData.selectionStyle = .none
        imageCellData.reuseIdentifier = HDImageTypeCell
        section0.contents.append(imageCellData)
        
        let cellData = HDTwoLabelTableViewCellViewData()
        cellData.text1 = "DOB"
        cellData.text2 = (employee.dateOfBirth!.getWithHDFormat())
        cellData.reuseIdentifier = HDTwoLabelTypeCell
        
        section0.contents.append(cellData)
        
        if employee.address != nil {
            let cellData = HDTwoLabelTableViewCellViewData()
            cellData.text1 = "Address"
            cellData.text2 = employee.address!
            cellData.isSemiBold = false
            cellData.reuseIdentifier = HDTwoLabelTypeCell
            section0.contents.append(cellData)
        }
        
        let genderCellData = HDTwoLabelTableViewCellViewData()
        genderCellData.text1 = "Gender"
        genderCellData.text2 = employee.gender!
        genderCellData.reuseIdentifier = HDTwoLabelTypeCell
        section0.contents.append(genderCellData)
        
        if employee.hobbies != nil {
            let cellData = HDTwoLabelTableViewCellViewData()
            cellData.text1 = "Hobbies"
            if employee.hobbies != nil {
                let hobbies = self.nsDataToStringArray(nsData: (employee.hobbies)!)
                if hobbies.count > 0 {
                    cellData.text2 = hobbies.joined(separator: ", ")
                }else {
                    cellData.text2 = ""
                }
            }else {
                cellData.text2 = ""
            }
            cellData.reuseIdentifier = HDTwoLabelTypeCell
            
            section0.contents.append(cellData)
        }
        
        sections.add(section0)
        self.dataSet = HDTableDataSet(sections: sections as [AnyObject])
        self.tableView.reloadData()
    }

	@IBAction func editDetailsAction(_ sender: UIButton) {
		let addemployeeDetailsVC = HDAddEmployeeDetailsViewController(employeeLaunchType: EmployeeLaunchType.editEmployee(), employee: self.employee)
		addemployeeDetailsVC.delegate = self
		self.navigationController?.pushViewController(addemployeeDetailsVC, animated: true)
	}

	fileprivate func nsDataToStringArray(nsData: NSData) -> [String] {
		let data = nsData as Data
		return data.split(separator: 0).flatMap { String(bytes: $0, encoding: .utf8) }
	}

	//MARK: UITableViewDelegate, UITableViewDataSource Methods

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSet.numberOfRowsForSection(section: section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath) as! HDTableViewCellData
		let cell = self.tableView.dequeueReusableCell(withIdentifier: viewData.reuseIdentifier, for: indexPath) as! HDCustomCell
		cell.updateViewWithData(viewData: viewData)
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 85
		}
		return UITableViewAutomaticDimension
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	//MARK: HDAddEmployeeDetailsViewControllerDelegate
	func didUpdateEmployee(employee:Employee) {
		self.employee = employee
		self.updateTableView()
		delegate?.updatedEmployee()
	}
}
