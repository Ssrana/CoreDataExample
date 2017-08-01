//
//  HDPreferencesData.swift
//  CoreDataDemo
//
//  Created by Sanchika on 31/07/17.
//  Copyright © 2017 demo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class HDPreferencesData {
    
    static let sharedInstance = HDPreferencesData()
    var preferences = [Preferences]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getPreferencesData() {
        
        do {
            preferences = try context.fetch(Preferences.fetchRequest())
            addPreferences()
        }catch {
            print("Error fetching data from CoreData")
        }
    }
    
    func addPreferences() {
        
        if preferences.count == 0 {
            
            let settings = Preferences(context: context)
            settings.sortedBy = "name"
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func updatePreferences(SortedBy: String) {
        
        let request = NSFetchRequest<Preferences>(entityName: "Preferences")
        
        do {
            let searchResults = try context.fetch(request)
            
            searchResults[0].sortedBy = SortedBy
            
        } catch {
            print("Error with request: \(error)")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
