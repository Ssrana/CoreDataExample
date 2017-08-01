//
//  HDEmployeTableViewCell.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import UIKit

class HDEmployeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
		self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width/2
		self.profileIcon.clipsToBounds = true
    }

    static func registerCellForTableView(_ tableView:UITableView) {
        tableView.register(UINib(nibName: "HDEmployeTableViewCell", bundle: nil), forCellReuseIdentifier: "HDEmployeTableViewCell")
    }
    
    static func reusableCellForTableView(_ tableView:UITableView, indexPath:IndexPath)-> HDEmployeTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "HDEmployeTableViewCell") as! HDEmployeTableViewCell
    }
}
