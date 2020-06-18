//
//  FLDataManager.swift
//  FartLogger
//
//  Created by James Lane on 6/15/20.
//  Copyright © 2020 James Lane. All rights reserved.
//

import CoreData
import UIKit

protocol FLDataManagerDelegate {
    func fartSoundDetected(confidence : Double)
}

class FLDataManager {
 
    static let shared : FLDataManager = FLDataManager()
    
    func saveData() {
        
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
           return
         }
         
        do {
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            try managedContext.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func insertNewFartEntry(entry : FartEntry) {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext =
          appDelegate.persistentContainer.viewContext
        let newEntry = CDFartEntry(context: managedContext)
        managedContext.insert(newEntry)
        newEntry.timestamp = entry.timestamp

        self.saveData()
    }
    
    func removeAll() {
        guard let appDelegate =
                 UIApplication.shared.delegate as? AppDelegate else {
                 return
               }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        for object in managedContext.registeredObjects {
            
            managedContext.delete(object)
        }
        
        self.saveData()
    }
    
    func deleteEntry(entry: FartEntry) {
        
        guard let appDelegate =
                 UIApplication.shared.delegate as? AppDelegate else {
                 return
               }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // Find CD Object to remove
   
               let fetchRequest =
                 NSFetchRequest<CDFartEntry>(entityName: "CDFartEntry")
               
               //3
               do {
                let entries = try managedContext.fetch(fetchRequest)
                
                for e in entries {
                    if e.valueObject == entry {
                        managedContext.delete(e)
                    }
                }
                
                
               } catch let error as NSError {
                 print("Could not fetch. \(error), \(error.userInfo)")
               }
        
        self.saveData()
        
    }
    
    var currentFartEntries : [FartEntry] {
        
        var entries : [CDFartEntry] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                       return []
            }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
  
        //2
        let fetchRequest =
          NSFetchRequest<CDFartEntry>(entityName: "CDFartEntry")
        
        //3
        do {
         entries = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var fartEntries : [FartEntry] = []
        
        for e in entries {
            fartEntries.append(e.valueObject!)
        }
        
        
        return fartEntries
    }
    
}

//MARK: - FLDataManagerDeletate

extension FLDataManager : FLDataManagerDelegate {
    
    // Tell the data manager we detected a fart and should create a new data entry
    
    func fartSoundDetected(confidence : Double) {
        
        let now = Date()
        self.insertNewFartEntry(entry: FartEntry(timestamp: now, confidence: confidence))
     }
}
