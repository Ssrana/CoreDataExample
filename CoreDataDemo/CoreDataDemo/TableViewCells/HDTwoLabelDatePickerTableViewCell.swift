//
//  HDTwoLabelDatePickerTableViewCell.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

protocol HDTwoLabelDatePickerTableViewCellDelegate: NSObjectProtocol {
	func twoLabelDatePickerTableViewDidChange(text:String?, date:NSDate, cell:HDTwoLabelDatePickerTableViewCell)
}

class HDTwoLabelDatePickerTableViewCellViewData : HDTableViewCellData {
	var text1 = ""
	var text2 = ""
	var picker = false
}

class HDTwoLabelDatePickerTableViewCell: HDCustomCell {

	@IBOutlet weak var lineOneLabel: UILabel!
	@IBOutlet weak var lineTwoLabel: UILabel!
	@IBOutlet weak var seperator: UILabel!
	@IBOutlet weak var datePicker: UIDatePicker!

	var dataForPicker:[String]?
	weak var cellDelegate:HDTwoLabelDatePickerTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

	static func registerCellForTableView(_ tableView:UITableView, identifier:String) {
		tableView.register(UINib(nibName: "HDTwoLabelDatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
	}

	static func reusableCellForTableView(_ tableView:UITableView, indexPath:IndexPath)-> HDTwoLabelDatePickerTableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "HDTwoLabelDatePickerTableViewCell") as! HDTwoLabelDatePickerTableViewCell
	}

	override func updateViewWithData(viewData: HDTableViewCellData) {
		let data = viewData as! HDTwoLabelDatePickerTableViewCellViewData
		self.lineOneLabel.text = data.text1
		self.lineTwoLabel.text = data.text2
		self.selectionStyle = viewData.selectionStyle
		self.accessoryType = viewData.accessoryType
		
	}

	@IBAction func datePickerValueChanged(_ sender: Any) {
		self.cellDelegate?.twoLabelDatePickerTableViewDidChange(text: nil, date: self.datePicker.date as NSDate, cell: self)
		self.lineTwoLabel.text = self.datePicker.date.getWithHDDayFormat(true)
	}

}
