//
//  HDHobbiesViewController.swift
//  CoreDataDemo
//
//  Created by Sanchika on 29/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

protocol HDHobbiesViewControllerDelegate:NSObjectProtocol {
	func didChangeHobbies(value:[String])
}

class HDHobbiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!

	let hobbiesArray = ["Cricket","Football","Coding","Reading","Listing Music","Watching Movies","Swimming"]

	var hobbiesData:NSData?
	var selectedHobbies = [String]()
	var submitButton = UIBarButtonItem()
	weak var delegate:HDHobbiesViewControllerDelegate?

    override func viewDidLoad() {
		super.viewDidLoad()
		if self.hobbiesData != nil {
			selectedHobbies = self.nsDataToStringArray(nsData: hobbiesData!)
		}
		self.setNavBarDetails()
    }

	final func setNavBarDetails() {
		submitButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HDHobbiesViewController.doneHobbiesAction(_:)))
		submitButton.isEnabled = false
		navigationItem.rightBarButtonItems = [submitButton]
		self.title = "Hobbies"

	}

	@IBAction func doneHobbiesAction(_ sender: UIButton){
		self.delegate!.didChangeHobbies(value: self.selectedHobbies)
		self.navigationController?.popViewController(animated: true)
	}

	//MARK: UITableViewDataSource, UITableViewDelegate Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hobbiesArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
		let hobby = hobbiesArray[indexPath.row]
		cell.textLabel?.text = hobby
		if selectedHobbies.isEmpty == false {
			if selectedHobbies.contains(hobby) {
				cell.accessoryType = .checkmark
			}else {
				cell.accessoryType = .none
			}
		}
		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60;
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.submitButton.isEnabled = true
		let object = hobbiesArray[indexPath.row]
		tableView.beginUpdates()
		if selectedHobbies.isEmpty {
			selectedHobbies.append(object)
		}else {
			var itemFound = false
			for item in selectedHobbies {
				if item == object {
					selectedHobbies.remove(at: selectedHobbies.index(of: item)!)
					itemFound = true
					break
				}
			}
			if itemFound == false {
				selectedHobbies.append(object)
			}
		}
		tableView.reloadRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
	}

	fileprivate func nsDataToStringArray(nsData: NSData) -> [String] {
		let data = nsData as Data
		return data.split(separator: 0).flatMap { String(bytes: $0, encoding: .utf8) }
	}
}
