//
//  HDDateExtension.swift
//  CoreDataDemo
//
//  Created by Sanchika on 29/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation

enum HDDay: Int {
	case morning = 10,
	afternoon = 15,
	evening = 19,
	night = 21
}

extension Date
{
	func dayOfWeek() -> Int? {

		let cal: Calendar = Calendar.current
		let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self)
		return comp.weekday
	}

	func isDateInToday() -> Bool {

		let cal: Calendar = Calendar.current
		return cal.isDateInToday(self)
	}

	func getWithHDFormat(_ displayTodayTomorrow:Bool = true) -> String {

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US")

		// check the date is less than tomorrow night 12
		var datePlusTwoDay = Date(timeIntervalSinceNow: (2*24*60*60))
		datePlusTwoDay = datePlusTwoDay.dateWith(0, minute: 0, second: 0)

		var dateTodayFirstSec = Date()
		dateTodayFirstSec = dateTodayFirstSec.dateWith(0, minute: 0, second: 0)

		if displayTodayTomorrow == true && self.timeIntervalSinceNow <  datePlusTwoDay.timeIntervalSinceNow && self.timeIntervalSinceNow >= dateTodayFirstSec.timeIntervalSinceNow {
			dateFormatter.doesRelativeDateFormatting = true
			dateFormatter.dateStyle = DateFormatter.Style.medium
			dateFormatter.timeStyle = .none

			var result = dateFormatter.string(from: self)
			let formatString = "h:mm a"
			dateFormatter.dateFormat = formatString
			result = result + ", " + dateFormatter.string(from: self)

			return result

		} else {

			var currentYear = true
			if Date().getYear() != self.getYear() {
				currentYear = false
			}
			var formatString = "d MMM"

			if currentYear == false {
				formatString += " yyyy"
			}

			dateFormatter.dateFormat = formatString
		}

		return dateFormatter.string(from: self)
	}

	func getWithHDDayFormat(_ shouldUseEnglish:Bool = false) -> String {

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US")

		// check the date is less than tomorrow night 12
		var datePlusTwoDay = Date(timeIntervalSinceNow: (2*24*60*60))
		datePlusTwoDay = datePlusTwoDay.dateWith(0, minute: 0, second: 0)

		var dateTodayFirstSec = Date()
		dateTodayFirstSec = dateTodayFirstSec.dateWith(0, minute: 0, second: 0)

		if self.timeIntervalSinceNow <  datePlusTwoDay.timeIntervalSinceNow {
			// check of it falls in to next day (2days)
			dateFormatter.doesRelativeDateFormatting = true
			dateFormatter.dateStyle = DateFormatter.Style.medium
			dateFormatter.timeStyle = .none
		} else {
			var formatString = "EEE, d MMM"
			if dateTodayFirstSec.getYear() != self.getYear() {
				formatString = "EEE, d MMM yyyy"
			}

			dateFormatter.dateFormat = formatString
		}

		return dateFormatter.string(from: self)
	}

	func dateWith(_ hour:Int, minute:Int, second:Int) -> Date {

		let cal: Calendar = Calendar.current
		let unitFlags: NSCalendar.Unit = [.day, .month, .year]

		var comp: DateComponents = (cal as NSCalendar).components(unitFlags, from: self)
		comp.hour = hour
		comp.minute = minute
		comp.second = second

		let date = cal.date(from: comp)
		return date!
	}

	func getHour() -> Int {

		let cal: Calendar = Calendar.current
		let unitFlags: NSCalendar.Unit = [.hour]
		let comp: DateComponents = (cal as NSCalendar).components(unitFlags, from: self)
		return comp.hour!
	}

	func getYear() -> Int {

		let cal: Calendar = Calendar.current
		let unitFlags: NSCalendar.Unit = [.year]
		let comp: DateComponents = (cal as NSCalendar).components(unitFlags, from: self)
		return comp.year!
	}

	func getDay() -> Int {

		let cal: Calendar = Calendar.current
		let unitFlags: NSCalendar.Unit = [.day]
		let comp: DateComponents = (cal as NSCalendar).components(unitFlags, from: self)
		return comp.day!
	}

	func getMinute() -> Int {

		let cal: Calendar = Calendar.current
		let unitFlags: NSCalendar.Unit = [.minute]
		let comp: DateComponents = (cal as NSCalendar).components(unitFlags, from: self)
		return comp.minute!
	}
}

extension String
{
	func getDates() -> [Date] {
		return self.getDatesInternal(true)
	}

	func getAllDates() -> [Date] {

		return self.getDatesInternal(false)
	}

	fileprivate func getDatesInternal(_ onlyFromStarting:Bool) -> [Date] {

		let error: NSErrorPointer? = nil
		let detector: NSDataDetector?

		do {
			detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
		} catch let error1 as NSError {
			error??.pointee = error1
			detector = nil
		}

		let results = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, self.utf16.count))

		var dates = [AnyObject]()

		if results != nil {
			for result in results! {
				let item = result
				let range = item.rangeAt(0)

				if (onlyFromStarting == true) {
					if (range.location == 0) {// consider items detected from the starting only
						dates.append(item)
					}
				} else {
					dates.append(item)
				}
			}
		}

		return dates.filter { date in
			return date.date != nil
			}.map { link -> Date in
				return link.date!!
		}
	}
}

class DateSuggestion: NSObject
{
	var displayString:String!
	var timestamp:TimeInterval!
}

class HDDateSuggestion: NSObject
{
	var currentSearchString:String = ""
	var timeIncluded = true

	func correctTime(_ date:Date) -> Date {

		let newDate = Date(timeIntervalSince1970: date.timeIntervalSince1970 + (2*60*60))
		return newDate.dateWith(newDate.getHour(), minute: 0, second: 0)
	}

	func getDefaultSuggestions() -> Array <DateSuggestion> {

		let suggestions = [DateSuggestion]()
		return suggestions
	}

	func getDateForDay(_ dayString:String) -> Date {

		var index = 0
		switch (dayString) {
		case "mon":
			index = 2
		case "tue":
			index = 3
		case "wed":
			index = 4
		case "thu":
			index = 5
		case "fri":
			index = 6
		case "sat":
			index = 7
		case "sun":
			index = 8
		default:
			index = 0

		}

		let currentDay = Date()
		let weekdayForToday:Int = currentDay.dayOfWeek()!
		let offset = (7 + index) - weekdayForToday

		let newDate = Date(timeIntervalSince1970: currentDay.timeIntervalSince1970 + Double((60*60*24*offset)))
		return newDate
	}
}
