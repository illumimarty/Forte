//
//  Repertoire+CoreDataProperties.swift
//  Forte
//
//  Created by Marty Nodado on 11/16/23.
//
//

import Foundation
import CoreData

extension Repertoire {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repertoire> {
        return NSFetchRequest<Repertoire>(entityName: "Repertoire")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var ensemble: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var startDate: Date?

}

extension Repertoire: Identifiable {

}
