//
//  HDTableDataSet.swift
//  CoreDataDemo
//
//  Created by Sanchika on 28/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import UIKit


class HDTableDataSet: NSObject, NSCopying {

	var sections = [AnyObject]()

	init(sections: [AnyObject]?=nil) {
		if sections != nil {
			self.sections = sections!
		}
		super.init()
	}

	func initWithSections(sections:[AnyObject]) {
		self.sections = sections
	}

	func copy(with zone: NSZone? = nil) -> Any {
		let newSections = NSArray(array: self.sections, copyItems: true)
		return self.initWithSections(sections: newSections as! [HDTableSection])
	}

	func allRows()-> [AnyObject] {
		var rows = [AnyObject]()
		for section in self.sections {
			rows.append(section)
		}
		return rows;
	}

	func isEmpty() -> Bool {
		return self.allRows().count == 0;
	}

	func numberOfSections()-> Int {
		return self.sections.count
	}

	func numberOfRowsForSection(section:Int) -> Int {
		if self.sections.count == 0 {
			return 0
		}
		let tableSection = self.sections[section] as! HDTableSection;
		return tableSection.contents.count;
	}

	func sectionForIndex(index:Int) -> HDTableSection? {
		if self.sections.count == 0 {
			return nil
		}
		return self.sections[index] as? HDTableSection;

	}

	func objectForIndexPath(indexPath:IndexPath) -> Any? {
		if self.sections.count == 0 {
			return nil
		}
		let tableSection = self.sections[indexPath.section] as! HDTableSection;
		if (tableSection.contents.count > indexPath.row) {
			return tableSection.contents[indexPath.row];
		}
		return nil
	}

	func indexPathForObject(object:AnyObject) -> IndexPath? {
		var indexPathSection = NSNotFound
		var indexPathRow = NSNotFound
		let numberOfSections = self.numberOfSections()
		for i in 0..<numberOfSections {
			let section = self.sections[i] as! HDTableSection
			indexPathSection = i;
			indexPathRow = (section.contents as AnyObject).index(of: object)
			if indexPathRow == NSNotFound {
				break
			}
		}

		if (indexPathRow == NSNotFound || indexPathSection == NSNotFound) {
			return nil;
		}
		return IndexPath(row: indexPathRow, section: indexPathSection)
	}
}

