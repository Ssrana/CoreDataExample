//
//  HDImageTableViewCell.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

protocol HDImageTableViewCellDelegate: NSObjectProtocol {
	func imageTableCellDelegateDidChange(name:String, cell:HDImageTableViewCell)
    func processImagePicker(cell:HDImageTableViewCell)
}

class HDImageTableViewCellViewData : HDTableViewCellData {

	var text1 = ""
	var text2 = ""
    var imageData:Data? = nil
	var editButtonTitle = ""
	var editButtonEnabled = true
	var placeHolderText = ""
}

class HDImageTableViewCell: HDCustomCell {

	@IBOutlet weak var profileIcon: UIImageView!
	@IBOutlet weak var editButton: UIButton!	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var nameTextField: UITextField!

	weak var cellDelegate:HDImageTableViewCellDelegate?

	@IBAction func editProfileImageButtonTapped(_ sender: Any) {
        self.cellDelegate!.processImagePicker(cell: self)
	}

	@IBAction func nameTextFieldEditingChanged(_ sender: Any) {
		self.cellDelegate?.imageTableCellDelegateDidChange(name: self.nameTextField.text!, cell: self)
	}

	@IBAction func nameTextFieldEditingDidBegin(_ sender: Any) {

	}

	@IBAction func nameTextFieldValueChanged(_ sender: Any) {

	}

    override func awakeFromNib() {
        super.awakeFromNib()
		self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width/2
		self.profileIcon.clipsToBounds = true
    }

	static func registerCellForTableView(_ tableView:UITableView, identifier:String) {
		tableView.register(UINib(nibName: "HDImageTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
	}

	static func reusableCellForTableView(_ tableView:UITableView, indexPath:IndexPath)-> HDImageTableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "HDImageTableViewCell") as! HDImageTableViewCell
	}

	override func updateViewWithData(viewData: HDTableViewCellData) {
		let data = viewData as! HDImageTableViewCellViewData
		self.nameLabel.text = data.text1
		if data.text2.isEmpty == false {
			self.nameTextField.text = data.text2
		}
        if data.imageData == nil {
            self.profileIcon.image = UIImage(named: "people_default")
        }else {
            self.profileIcon.image = UIImage(data: data.imageData!)
        }
        self.selectionStyle = data.selectionStyle
		self.nameTextField.placeholder = data.placeHolderText
		self.editButton.setTitle(data.editButtonTitle, for: .normal)
		if data.editButtonEnabled == false {
			self.editButton.isEnabled = false
			self.editButton.isHidden = true
			self.nameTextField.isUserInteractionEnabled = false
		}
	}
    
    func setImageDetails(thumbnailData:Data) {
        self.profileIcon.image = UIImage(data: thumbnailData)
    }
}
