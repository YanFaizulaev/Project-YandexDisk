//
//  LastFiles+CoreDataProperties.swift
//  Skillbox Drive
//
//  Created by Bandit on 01.03.2023.
//
//

import Foundation
import CoreData


extension LastFiles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastFiles> {
        return NSFetchRequest<LastFiles>(entityName: "LastFiles")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var size: Int64
    @NSManaged public var preview: String?
    @NSManaged public var path: String?
    @NSManaged public var modified: String?
    @NSManaged public var mime_type: String?
    @NSManaged public var file: String?
    @NSManaged public var created: String?

}

extension LastFiles : Identifiable {

}
