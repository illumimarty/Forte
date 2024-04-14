//
//  Composition+CoreDataProperties.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
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
    @NSManaged public var recordingLink: String?
    @NSManaged public var ensemble: Ensemble?
	@NSManaged public var progressValue: Float
    @NSManaged public var section: NSSet?

}

// MARK: Generated accessors for section
extension Composition {

    @objc(addSectionObject:)
    @NSManaged public func addToSection(_ value: Passage)

    @objc(removeSectionObject:)
        @NSManaged public func removeFromSection(_ value: Passage)

    @objc(addSection:)
    @NSManaged public func addToSection(_ values: NSSet)

    @objc(removeSection:)
    @NSManaged public func removeFromSection(_ values: NSSet)

}

extension Composition: Identifiable {

}

extension Composition {
	var viewModel: CompositionVM {
		.init(name: name ?? "Composition Name", composer: composer ?? "Composer", recordingLink: recordingLink ?? "Insert Link Here")
	}
}

struct CompositionVM {
	var name: String?
	var composer: String?
	var recordingLink: String?
}
