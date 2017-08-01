//
//  HDTableSection.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import UIKit


class HDTableSection: NSObject, NSCopying {

	var title = ""
	var contents = [AnyObject]()
	var headerHeight = 0
	var headerTitle = "";
	var headerBackgroundColor = UIColor.clear
	var footerHeight = 0
	var footerTitle = ""
	var footerBackgroundColor = UIColor.clear

	func copy(with zone: NSZone? = nil) -> Any {
		let copy = self.copy(with: zone) as! HDTableSection
		copy.title = self.title;
		copy.contents = self.contents;
		copy.headerTitle = self.headerTitle;
		copy.headerBackgroundColor = self.headerBackgroundColor;
		copy.footerHeight = self.footerHeight;
		copy.footerTitle = self.footerTitle;
		copy.footerBackgroundColor = self.footerBackgroundColor;
		return copy;
	}

	static func tableSectionWithContent(content:[HDTableSection], title:String)-> HDTableSection {
		let section = HDTableSection()
		section.title = title;
		section.contents = content;
		return section;
	}

	func count() -> Int{
		return self.contents.count
	}
}
