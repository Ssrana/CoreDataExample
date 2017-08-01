//
//  HDCustomCell.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import UIKit

class HDCustomCell: UITableViewCell {

	func updateViewWithData(viewData: HDTableViewCellData)  {
		self.accessoryType = viewData.accessoryType
		if(viewData.isDisabled) {
			self.selectionStyle = .none
		} else {
			self.selectionStyle = .default
		}
		self.selectionStyle = viewData.selectionStyle
	}

	static func registerForTableView(tableView:UITableView) {
		tableView.register(UINib(nibName: NSStringFromClass(self), bundle: nil), forCellReuseIdentifier: self.reuseIdentifier())
	}

	static func reuseIdentifier()-> String {
		return NSStringFromClass(self);
	}
}
