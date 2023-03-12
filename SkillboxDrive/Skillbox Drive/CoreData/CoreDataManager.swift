//
//  CoreDataManager.swift
//  Skillbox Drive
//
//  Created by Bandit on 28.02.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let persistentContainer : NSPersistentContainer
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "Skillbox_Drive")
    }
    
    func loadCoreDataRecently(){
        persistentContainer.loadPersistentStores { nspersistentstoredescription, error in
            if let error = error {
                print(error)
            } else {
                print("Loaded CoreData")
            }
        }
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
                try? context.save()
            }
            print("Done! CoreData - \(entity) deleted")
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
}
