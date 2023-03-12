//
//  AllFilesClass.swift
//  Skillbox Drive
//
//  Created by Bandit on 01.03.2023.
//

import Foundation
import CoreData

class AllFilesClass {
    
    private lazy var fetchedResultController : NSFetchedResultsController<AllFiles> = {
        let fetchRequest = AllFiles.fetchRequest()
        let sort = NSSortDescriptor(key:"name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    
    func saveToCoreData(array: [Items]){
        let fetchRequest = AllFiles.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            let arrayFetched = try fetchedResultController.managedObjectContext.fetch(fetchRequest)
            if arrayFetched.isEmpty && !array.isEmpty {
                array.forEach { file in
                  let newFile = AllFiles.init(entity: NSEntityDescription.entity(forEntityName: "AllFiles", in: CoreDataManager.shared.context)!, insertInto: CoreDataManager.shared.context)
                    newFile.created = file.created
                    newFile.file = file.file
                    newFile.mime_type = file.mime_type
                    newFile.modified = file.modified
                    newFile.name = file.name
                    newFile.path = file.path
                    newFile.preview = file.preview
                    newFile.size = Int64(file.size ?? 0)
                    newFile.type = file.type
                    try? newFile.managedObjectContext?.save()
                }
            } else {
                let convertedArray = arrayFetched.map{Items(name: $0.name,
                                                            preview: $0.preview,
                                                            created: $0.created,
                                                            modified: $0.modified,
                                                            path: $0.path,
                                                            type: $0.type,
                                                            mime_type: $0.mime_type,
                                                            size: Int($0.size),
                                                            file: $0.file)
                }
                
                let arraySaveToData = array.filter { item in
                    !convertedArray.contains (where: { file in
                        item.path == file.path
                    })
                }
                
                arraySaveToData.forEach { file in
                    let newFile = AllFiles.init(entity: NSEntityDescription.entity(forEntityName: "AllFiles", in: CoreDataManager.shared.context)!, insertInto: CoreDataManager.shared.context)
                    newFile.created = file.created
                    newFile.file = file.file
                    newFile.mime_type = file.mime_type
                    newFile.modified = file.modified
                    newFile.name = file.name
                    newFile.path = file.path
                    newFile.preview = file.preview
                    newFile.size = Int64(file.size ?? 0)
                    newFile.type = file.type
                      try? newFile.managedObjectContext?.save()
                }
                
                let arrayDeleteFromData = convertedArray.filter { item in
                    !array.contains (where: { file in
                        item.path == file.path
                    })
                }
                
                let fetchRequestDelete = AllFiles.fetchRequest()
                arrayDeleteFromData.forEach { file in
                    if let fileName = file.path {
                        let predicate = NSPredicate(format: "path == %@", fileName)
                        fetchRequestDelete.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
                    }
                    do {
                        let objct = try fetchedResultController.managedObjectContext.fetch(fetchRequestDelete)
                        if !objct.isEmpty {
                        objct.forEach { file in
                            fetchedResultController.managedObjectContext.delete(file)
                        }
                        try fetchedResultController.managedObjectContext.save()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func connectContext() -> [Items]{
        var returnArray : [Items] = []
        let fetch = AllFiles.fetchRequest()
        let sort = NSSortDescriptor(key: "created", ascending: false)
        fetch.sortDescriptors = [sort]
        do {
        let result = try self.fetchedResultController.managedObjectContext.fetch(fetch)
            for item in result{
                returnArray.append(Items(name: item.name,
                                         preview: item.preview,
                                         created: item.created,
                                         modified: item.modified,
                                         path: item.path,
                                         type: item.type,
                                         mime_type: item.mime_type,
                                         size: Int(item.size),
                                         file: item.file))
            }
        } catch {
            print(error)
        }
        return returnArray
    }
    
    func saveData(){
    if fetchedResultController.managedObjectContext.hasChanges {
        do {
            try CoreDataManager.shared.context.save()
            print("Save is done")
        } catch {
            print("Erorr! Saving failed!", error)
            }
        }
    }
}
