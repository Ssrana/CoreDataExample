//
//  HDTextFieldTableViewCell.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

protocol HDTextFieldTableViewCellDelegate: NSObjectProtocol {
	func textFieldTableViewCellDidChange(text:String, cell:HDTextFieldTableViewCell)
}

class HDTextFieldTableViewCellData : HDTableViewCellData {
	var text1 = ""
	var text2 = ""
	var placeHolderText = ""
}

class HDTextFieldTableViewCell: HDCustomCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var textField: UITextField!

	weak var cellDelegate:HDTextFieldTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

	@IBAction func textFieldEditingChanged(_ sender: Any) {
		self.cellDelegate!.textFieldTableViewCellDidChange(text: self.textField.text!, cell: self)
	}

	@IBAction func textFieldEditingDidEnd(_ sender: Any) {
	}

	@IBAction func textFieldEditingDidBegin(_ sender: Any){
	}

	@IBAction func textFieldValueChanged(_ sender: Any) {
	}

	static func registerCellForTableView(_ tableView:UITableView, identifier:String) {
		tableView.register(UINib(nibName: "HDTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
	}

	static func reusableCellForTableView(_ tableView:UITableView, indexPath:IndexPath)-> HDTextFieldTableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "HDTextFieldTableViewCell") as! HDTextFieldTableViewCell
	}

	override func updateViewWithData(viewData: HDTableViewCellData) {
		let data = viewData as! HDTextFieldTableViewCellData
		self.titleLabel.text = data.text1
		self.textField.placeholder = data.placeHolderText
		self.textField.text = data.text2
		self.selectionStyle = data.selectionStyle
	}
}
