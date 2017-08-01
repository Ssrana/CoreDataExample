//
//  HDAddEmployeeDetailsViewController.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

enum HDCellKind: Int {
	case ImageNameType = 0,
	DesignationType = 1,
	DOBType = 2,
	AddressType = 3,
	GenderType = 4,
	HobbiesType = 5
};

let HDTwoLabelTypeCell:String = "HDTwoLabelTypeCell"
let HDDiscolureTypeCell:String = "HDDisclosureTypeCell"
let HDTextFieldTypeCell:String = "HDTextFieldTypeCell"
let HDImageTypeCell:String = "HDImageTypeCell"


@objc protocol HDAddEmployeeDetailsViewControllerDelegate:NSObjectProtocol {
    @objc optional func didAddEMployee(isAdded: Bool)
	@objc optional func didUpdateEmployee(employee:Employee)
}

class HDAddEmployeeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HDImageTableViewCellDelegate, HDTwoLabelDatePickerTableViewCellDelegate, HDTextFieldTableViewCellDelegate, HDGenderViewControllerDelegate, HDHobbiesViewControllerDelegate {

    let imagePicker = UIImagePickerController()
    let convertQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)
    let saveQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)

    var cellRefernce:HDImageTableViewCell?
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

	var dataSet = HDTableDataSet()
	var employeeLaunchType:EmployeeLaunchType
	var employeeHelper = HDEmployeeDataHelper()
	var employee:Employee?
	var expandedIndexPath:IndexPath?

    weak var delegate: HDAddEmployeeDetailsViewControllerDelegate?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	init(employeeLaunchType:EmployeeLaunchType, employee:Employee?) {
        self.employeeLaunchType = employeeLaunchType
		self.employee = employee
        super.init(nibName: "HDAddEmployeeDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setUpBasicUI()
		self.setNavBarDetails()
        
        imagePickerSetup() // image picker delegate and settings
        
		switch self.employeeLaunchType {
		case .createEmployee():
			employee = Employee(context: self.context)
			employee!.dateAdded = Date()
			print("yes")
		case .editEmployee():
			print("edit")
		}
		self.updateTableView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		registerKeyboardEvents()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		unregisterKeyboardEvents()
	}


	fileprivate final func setNavBarDetails() {
		let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(HDAddEmployeeDetailsViewController.submitDetailsAction(_:)))
		navigationItem.rightBarButtonItems = [submitButton]
		self.title = "Details"
	}

	final func updateTableView() {
		let section0 = HDTableSection()
		let sections = NSMutableArray()

		let imageCellData = HDImageTableViewCellViewData()
		imageCellData.text1 = "Name"
		imageCellData.text2 = employee!.name ?? ""
        imageCellData.imageData = employee!.thumbnail
		imageCellData.editButtonTitle = "Edit"
		imageCellData.placeHolderText = "Please enter Name"
		imageCellData.cellKind = HDCellKind.ImageNameType.rawValue
		imageCellData.selectionStyle = .none
		imageCellData.reuseIdentifier = HDImageTypeCell
		imageCellData.selectionStyle = .none

		let designationCellData = HDTextFieldTableViewCellData()
		designationCellData.text1 = "Designation"
		designationCellData.text2 = employee?.designation ?? ""
		designationCellData.placeHolderText = "Please enter Designation"
		designationCellData.cellKind = HDCellKind.DesignationType.rawValue
		designationCellData.selectionStyle = .none
		designationCellData.reuseIdentifier = HDTextFieldTypeCell

		let dateOfbirthCellData = HDTwoLabelDatePickerTableViewCellViewData()
		dateOfbirthCellData.text1 = "DOB"
		if employee!.dateOfBirth != nil {
			dateOfbirthCellData.text2 = (employee!.dateOfBirth!.getWithHDFormat(true))
		}else {
			dateOfbirthCellData.text2 = ""
		}
		dateOfbirthCellData.cellKind = HDCellKind.DOBType.rawValue
		dateOfbirthCellData.selectionStyle = .gray
		dateOfbirthCellData.reuseIdentifier = HDTwoLabelTypeCell

		let addressCellData = HDTextFieldTableViewCellData()
		addressCellData.text1 = "Address"
		addressCellData.text2 = employee?.address ?? ""
		addressCellData.placeHolderText = "Please enter Address"
		addressCellData.cellKind = HDCellKind.AddressType.rawValue
		addressCellData.selectionStyle = .none
		addressCellData.reuseIdentifier = HDTextFieldTypeCell

		let genderCellData = HDTwoLabelDatePickerTableViewCellViewData()
		genderCellData.text1 = "Gender"
		genderCellData.text2 = employee?.gender ?? ""
		genderCellData.cellKind = HDCellKind.GenderType.rawValue
		genderCellData.selectionStyle = .gray
		genderCellData.reuseIdentifier = HDTwoLabelTypeCell
		genderCellData.displayDisclosure = true
		genderCellData.accessoryType = .disclosureIndicator

		let hobbiesCellData = HDTwoLabelDatePickerTableViewCellViewData()
		hobbiesCellData.text1 = "Hobbies"
		if employee?.hobbies != nil {
			let hobbies = self.nsDataToStringArray(nsData: (employee?.hobbies)!)
			if hobbies.count > 0 {
				hobbiesCellData.text2 = hobbies.joined(separator: ", ")
			}else {
				hobbiesCellData.text2 = ""
			}
		}else {
			hobbiesCellData.text2 = ""
		}
		hobbiesCellData.cellKind = HDCellKind.HobbiesType.rawValue
		hobbiesCellData.selectionStyle = .gray
		hobbiesCellData.reuseIdentifier = HDTwoLabelTypeCell
		hobbiesCellData.displayDisclosure = true
		hobbiesCellData.accessoryType = .disclosureIndicator

		section0.contents = [imageCellData, designationCellData, dateOfbirthCellData,addressCellData, genderCellData, hobbiesCellData ]

		sections.add(section0)
		self.dataSet = HDTableDataSet(sections: sections as [AnyObject])
		self.tableView.reloadData()
	}

	@IBAction func submitDetailsAction(_ sender: UIButton){
        if isValidateInputParamsForEmployeeData() {
            switch self.employeeLaunchType {
            case .createEmployee():
                delegate?.didAddEMployee!(isAdded: true)
            case .editEmployee():
                delegate?.didUpdateEmployee!(employee: employee!)
            }
            saveQueue.async {
                HDEmployee.sharedInstance.saveContextOnAddEmployee()
            }
            self.navigationController?.popViewController(animated: true)
        }
	}
    
    fileprivate func isValidateInputParamsForEmployeeData() -> Bool {
        // profilepic, name, designation, gender required fields
        if employee!.name == nil || employee!.name!.isEmpty {
            displayAlertWithMessage(message: "Name is required")
            return false
        }else if (employee!.gender == nil){
            displayAlertWithMessage(message: "Gender is required")
            return false
        }else if (employee!.dateOfBirth == nil) {
            displayAlertWithMessage(message: "Date of birth is required")
            return false
            
        }else if (employee!.profilePic == nil){
            displayAlertWithMessage(message: "Employee Pic is required")
            return false
        }
        return true
    }
    
    fileprivate func displayAlertWithMessage(message:String)  {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

	fileprivate func setUpBasicUI() {
		HDTextFieldTableViewCell.registerCellForTableView(self.tableView, identifier: HDTextFieldTypeCell)
		HDTwoLabelDatePickerTableViewCell.registerCellForTableView(self.tableView, identifier: HDTwoLabelTypeCell)
		HDImageTableViewCell.registerCellForTableView(self.tableView, identifier: HDImageTypeCell)
	}

	//MARK: UITableViewDelegate, UITableViewDataSource Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSet.numberOfRowsForSection(section: section)
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath) as! HDTableViewCellData
		if viewData.cellKind == HDCellKind.ImageNameType.rawValue {
			return 85
		}else if self.expandedIndexPath != nil && indexPath.compare(self.expandedIndexPath!) == .orderedSame {
			return 277
		}
		return 65
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return self.dataSet.numberOfSections()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath) as! HDTableViewCellData
		let cell = self.tableView.dequeueReusableCell(withIdentifier: viewData.reuseIdentifier, for: indexPath) as! HDCustomCell
		cell.updateViewWithData(viewData: viewData)
		if viewData.cellKind == HDCellKind.ImageNameType.rawValue {
			(cell as! HDImageTableViewCell).cellDelegate = self
		}else if (viewData.cellKind == HDCellKind.DOBType.rawValue) {
			(cell as! HDTwoLabelDatePickerTableViewCell).cellDelegate = self
		}else if (viewData.cellKind == HDCellKind.DesignationType.rawValue || viewData.cellKind == HDCellKind.AddressType.rawValue) {
			(cell as! HDTextFieldTableViewCell).cellDelegate = self
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath) as! HDTableViewCellData
		let cell = self.tableView.dequeueReusableCell(withIdentifier: viewData.reuseIdentifier, for: indexPath) as! HDCustomCell

		if viewData.cellKind == HDCellKind.DOBType.rawValue {
			self.tableView.beginUpdates()
			if self.expandedIndexPath?.compare(indexPath) == .orderedSame {
				self.expandedIndexPath = nil
				(cell as! HDTwoLabelDatePickerTableViewCell).datePicker.isHidden = true
			}else {
				self.expandedIndexPath = indexPath
				(cell as! HDTwoLabelDatePickerTableViewCell).datePicker.isHidden = false
			}
			self.tableView.endUpdates()
		}else if (viewData.cellKind == HDCellKind.GenderType.rawValue) {
			self.displayGenderVC()
		}else if (viewData.cellKind == HDCellKind.HobbiesType.rawValue) {
			self.displayHobbiesVC()
		}
	}

	fileprivate final func displayGenderVC() {
		let genderVC = HDGenderViewController(nibName: "HDGenderViewController", bundle: nil)
		genderVC.delegate = self
		self.navigationController!.pushViewController(genderVC, animated: true)
	}

	fileprivate final func displayHobbiesVC() {
		let hobbiesVC = HDHobbiesViewController(nibName: "HDHobbiesViewController", bundle: nil)
		hobbiesVC.delegate = self
		if employee?.hobbies != nil {
			hobbiesVC.hobbiesData = employee?.hobbies
		}
		self.navigationController!.pushViewController(hobbiesVC, animated: true)
	}

	//MARK:HDImageTableViewCellDelegate
	func imageTableCellDelegateDidChange(name: String, cell: HDImageTableViewCell) {
		let indexPath = self.tableView.indexPath(for: cell);
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath!) as! HDImageTableViewCellViewData
		if viewData.cellKind == HDCellKind.ImageNameType.rawValue {
			employee!.name = name
		}
	}
    func processImagePicker(cell: HDImageTableViewCell) {
        cellRefernce = cell
        self.presentImagePicker()
    }

	//MARk: HDTwoLabelDatePickerTableViewCellDelegate
	func twoLabelDatePickerTableViewDidChange(text: String?, date: NSDate, cell: HDTwoLabelDatePickerTableViewCell) {
		let indexPath = self.tableView.indexPath(for: cell);
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath!) as! HDTwoLabelDatePickerTableViewCellViewData
		if viewData.cellKind == HDCellKind.DOBType.rawValue {
			employee?.dateOfBirth = date as Date
		}
	}

	//MARK: HDTextFieldTableViewCellDelegate
	func textFieldTableViewCellDidChange(text: String, cell: HDTextFieldTableViewCell) {
		let indexPath = self.tableView.indexPath(for: cell);
		let viewData = self.dataSet.objectForIndexPath(indexPath: indexPath!) as! HDTextFieldTableViewCellData
		if viewData.cellKind == HDCellKind.DesignationType.rawValue {
			employee?.designation = text
		}else if (viewData.cellKind == HDCellKind.AddressType.rawValue){
			employee?.address = text
		}
	}

	//MARK: HDGenderViewControllerDelegate
	func didChangeGender(value: String) {
		employee?.gender = value
		self.updateTableView()
	}

	//MARK: HDHobbiesViewControllerDelegate
	func didChangeHobbies(value: [String]) {
		let data = self.stringArrayToNSData(array: value)
		employee?.hobbies = data
		self.updateTableView()
	}

	fileprivate func stringArrayToNSData(array: [String]) -> NSData {
		let data = NSMutableData()
		let terminator = [0]
		for string in array {
			if let encodedString = string.data(using: String.Encoding.utf8) {
				data.append(encodedString)
				data.append(terminator, length: 1)
			}
			else {
				NSLog("Cannot encode string \"\(string)\"")
			}
		}
		return data
	}

	fileprivate func nsDataToStringArray(nsData: NSData) -> [String] {
		let data = nsData as Data
		return data.split(separator: 0).flatMap { String(bytes: $0, encoding: .utf8) }
	}
    
    
    func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
/*
    @IBAction func load(sender: AnyObject) { // button action
        loadImages { (images) -> Void in
            if let thumbnailData = images?.last?.thumbnail?.imageData {
                let image = UIImage(data: thumbnailData)
                self.imageView.image = image
            }
        }
    }
 */
}

//MARK: UIKeyboard notification and actions
extension HDAddEmployeeDetailsViewController
{
	fileprivate func registerKeyboardEvents() {
		NotificationCenter.default.addObserver(self, selector: #selector(HDAddEmployeeDetailsViewController.keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(HDAddEmployeeDetailsViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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
