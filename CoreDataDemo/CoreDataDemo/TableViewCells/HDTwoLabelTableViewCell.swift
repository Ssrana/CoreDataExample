//
//  HDTwoLabelTableViewCell.swift
//  CoreDataDemo
//
//  Created by Sanchika on 29/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

class HDTwoLabelTableViewCellViewData : HDTableViewCellData {
	var text1 = ""
	var text2 = ""
	var isSemiBold = true
}

class HDTwoLabelTableViewCell: HDCustomCell {

	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	static func registerCellForTableView(_ tableView:UITableView, identifier:String) {
		tableView.register(UINib(nibName: "HDTwoLabelTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
	}

	static func reusableCellForTableView(_ tableView:UITableView, indexPath:IndexPath)-> HDTwoLabelTableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "HDTwoLabelTableViewCell") as! HDTwoLabelTableViewCell
	}

	override func updateViewWithData(viewData: HDTableViewCellData) {
		let data = viewData as! HDTwoLabelTableViewCellViewData
		self.titleLabel.text = data.text1
		self.descriptionLabel.text = data.text2
		if data.isSemiBold == true {
			self.descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
		}
		self.selectionStyle = data.selectionStyle
	}    
}
