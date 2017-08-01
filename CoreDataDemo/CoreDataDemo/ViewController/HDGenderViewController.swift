//
//  HDGenderViewController.swift
//  CoreDataDemo
//
//  Created by Sanchika on 29/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

protocol HDGenderViewControllerDelegate:NSObjectProtocol {
	func didChangeGender(value:String)
}

class HDGenderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!

	let genderArray = ["Male", "Female"]
	weak var delegate:HDGenderViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Gender"
    }

	//MARK: UITableViewDelegate, UITableViewDataSource Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return genderArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
		cell.textLabel?.text = genderArray[indexPath.row]
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
		let gender = genderArray[indexPath.row]
		self.delegate?.didChangeGender(value: gender)
		self.navigationController!.popViewController(animated: true)
	}
}
