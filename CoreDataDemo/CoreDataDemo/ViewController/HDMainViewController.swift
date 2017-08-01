//
//  HDMainViewController.swift
//  CoreDataDemo
//
//  Created by Sanchika on 27/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

class HDMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HDAddEmployeeDetailsViewControllerDelegate, HDEmployeeDetailsViewControllerDelagate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    var searchResults = [Employee]()
    var employees = [Employee]()
    var addemployeeDetailsVC:HDAddEmployeeDetailsViewController?
    var isInSearchMode = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HDEmployeTableViewCell.registerCellForTableView(self.tableView)
		self.navigationController?.navigationBar.isTranslucent = false;
		let addButton = UIBarButtonItem(image: UIImage(named: "add_employee")!,  style: .plain, target: self, action: #selector(HDMainViewController.addEmployeeAction(_:)))
		let searchButton = UIBarButtonItem(image: UIImage(named: "search_employee")!,  style: .plain, target: self, action: #selector(HDMainViewController.searchEmployeeAction(_:)))

		navigationItem.rightBarButtonItems = [addButton]
		navigationItem.leftBarButtonItems = [searchButton]
		self.title = "Employee"
        self.searchBar.placeholder = "Search for employee"
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyboardEvents()
    }
    
    final func getData() {
        employees = HDEmployee.sharedInstance.employeeData()
        
        // Setting sorted by
        
        HDPreferencesData.sharedInstance.getPreferencesData()
        let preferencesValue =  HDPreferencesData.sharedInstance.preferences[0].sortedBy!
        
        if preferencesValue == "name" {
            employees = employees.sorted { $0.name! < $1.name! }
        } else if preferencesValue == "date of birth" {
            employees = employees.sorted { $0.dateOfBirth! < $1.dateOfBirth! }
        } else if preferencesValue == "designation" {
            employees = employees.sorted { $0.designation! < $1.designation! }
        }
        
    }

	@IBAction func addEmployeeAction(_ sender: UIButton) {
			self.addemployeeDetailsVC = HDAddEmployeeDetailsViewController(employeeLaunchType: EmployeeLaunchType.createEmployee(), employee: nil)
		addemployeeDetailsVC!.delegate = self
		self.navigationController?.pushViewController(self.addemployeeDetailsVC!, animated: true)
	}

	@IBAction func searchEmployeeAction(_ sender: UIButton){

	}

    //MARK: UITableView delegate and datasource methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if self.employees.count > 0 && self.isInSearchMode == false {
			return 120
		}
		return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 120))
        if isInSearchMode == false {
            let customView = HDMainTableHeaderView.createView()
            customView.parentVC = self
            customView.setUserInterFace(employee: employees)
            _ = headerView.addFittingSubview(subView: customView)
        }
        
        return headerView;
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInSearchMode == true {
            return searchResults.count
        }
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDEmployeTableViewCell.reusableCellForTableView(tableView, indexPath: indexPath)
		var employee = employees[indexPath.row]
        if isInSearchMode  {
            employee = searchResults[indexPath.row]
        }
        cell.nameLabel.text = employee.name!
        cell.dobLabel.text = employee.dateOfBirth!.getWithHDFormat(true)
        cell.genderLabel.text = employee.gender
		cell.dateAddedLabel.text = employee.dateAdded!.getWithHDFormat(true)
        cell.profileIcon.image = UIImage(data: employee.thumbnail!)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var employee = employees[indexPath.row]
        if isInSearchMode {
            employee = searchResults[indexPath.row]
        }
        let employeeDetailsViewController = HDEmployeeDetailsViewController(employee: employee)
		employeeDetailsViewController.delegate = self
        self.navigationController!.pushViewController(employeeDetailsViewController, animated: true)
    }

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.delete) {
            var employee = employees[indexPath.row]
            if isInSearchMode {
                employee = searchResults[indexPath.row]
                searchResults.remove(at: indexPath.row)
                let indexOfSearchedEmployee = employees.index(of: employee)
                employees.remove(at: indexOfSearchedEmployee!)
            }else{
                employees.remove(at: indexPath.row)
            }
			HDEmployee.sharedInstance.removeEmployee(employee: employee)
			self.tableView.reloadData()
		}
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true
	}
    
    //MARK: HDAddEmployeeDetailsViewControllerDelegate Methods
    
    func didAddEMployee(isAdded: Bool) {
        if isAdded {   
            self.getData()
            self.tableView.reloadData()
        }
    }

	//MARK: HDEmployeeDetailsViewControllerDelagate
	func updatedEmployee() {
		self.getData()
		self.tableView.reloadData()
	}
    
    //MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        isInSearchMode = false
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
            if searchText.isEmpty == false {
                self.isInSearchMode = true
                self.searchResults = HDEmployee.sharedInstance.userSelectedContact(contactIdentifier: searchText)
            }
            self.tableView.reloadData()
        })
    }
    
    //MARK: ScrollView Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: UIKeyboard notification and actions
extension HDMainViewController
{
    fileprivate func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(HDMainViewController.keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HDMainViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    final func keyboardDidShow(_ notification: Notification) {
        let info = notification.userInfo
        let keyboardSize = ((info![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size)
        self.tableViewBottomConstraint.constant = keyboardSize.height
    }
    
    final func keyboardWillHide(_ notification: Notification) {
        self.tableViewBottomConstraint.constant = 0.0
    }
    
    fileprivate func unregisterKeyboardEvents()
    {
        NotificationCenter.default.removeObserver(self)
    }
}
