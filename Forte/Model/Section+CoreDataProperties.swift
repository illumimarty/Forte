//
//  Section+CoreDataProperties.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startMeasure: Int16
    @NSManaged public var endMeasure: Int16
    @NSManaged public var progressValue: Float
    @NSManaged public var notes: String?
    @NSManaged public var startRehearsalMark: String?
    @NSManaged public var endRehearsalMark: String?
    @NSManaged public var name: String?
    @NSManaged public var piece: Composition?

}

extension Section : Identifiable {

}
