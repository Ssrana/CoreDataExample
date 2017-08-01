//
//  HDTableViewCellData.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import UIKit

class HDTableViewCellData: NSObject {
	var reuseIdentifier = ""
	var displayDisclosure = false
	var accessoryType:UITableViewCellAccessoryType = .none
	var cellKind = 0
	var isDisabled = false
	var selectionStyle: UITableViewCellSelectionStyle = .none
}
