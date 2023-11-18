//
//  Composition+CoreDataProperties.swift
//  Forte
//
//  Created by Marty Nodado on 11/16/23.
//
//

import Foundation
import CoreData


extension Composition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Composition> {
        return NSFetchRequest<Composition>(entityName: "Composition")
    }

    @NSManaged public var composer: String?
    @NSManaged public var duration: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var recording_link: String?
    @NSManaged public var ensemble: Ensemble?

}

extension Composition : Identifiable {

}
