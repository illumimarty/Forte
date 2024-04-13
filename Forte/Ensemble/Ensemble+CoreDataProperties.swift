//
//  Ensemble+CoreDataProperties.swift
//  Forte
//
//  Created by Marty Nodado on 11/16/23.
//
//

import Foundation
import CoreData


extension Ensemble {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ensemble> {
        return NSFetchRequest<Ensemble>(entityName: "Ensemble")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var pieces: NSSet?

}

// MARK: Generated accessors for pieces
extension Ensemble {

    @objc(addPiecesObject:)
    @NSManaged public func addToPieces(_ value: Composition)

    @objc(removePiecesObject:)
    @NSManaged public func removeFromPieces(_ value: Composition)

    @objc(addPieces:)
    @NSManaged public func addToPieces(_ values: NSSet)

    @objc(removePieces:)
    @NSManaged public func removeFromPieces(_ values: NSSet)

}

extension Ensemble : Identifiable {

}
