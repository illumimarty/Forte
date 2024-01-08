//
//  Passage+CoreDataProperties.swift
//  Forte
//
//  Created by Marty Nodado on 11/20/23.
//
//

import Foundation
import CoreData

extension Passage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Passage> {
        return NSFetchRequest<Passage>(entityName: "Passage")
    }

    @NSManaged public var endMeasure: Int16
    @NSManaged public var endRehearsalMark: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var progressValue: Float
    @NSManaged public var startMeasure: Int16
    @NSManaged public var startRehearsalMark: String?
    @NSManaged public var piece: Composition?

}

extension Passage: Identifiable {

}
