//
//  AllFiles+CoreDataProperties.swift
//  Skillbox Drive
//
//  Created by Bandit on 01.03.2023.
//
//

import Foundation
import CoreData


extension AllFiles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllFiles> {
        return NSFetchRequest<AllFiles>(entityName: "AllFiles")
    }

    @NSManaged public var type: String?
    @NSManaged public var size: Int64
    @NSManaged public var preview: String?
    @NSManaged public var path: String?
    @NSManaged public var name: String?
    @NSManaged public var modified: String?
    @NSManaged public var mime_type: String?
    @NSManaged public var file: String?
    @NSManaged public var created: String?

}

extension AllFiles : Identifiable {

}
