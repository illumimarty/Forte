//
//  DataManager.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import CoreData
import Combine

enum ChangeType {
    case inserted, deleted, updated
    
    var userInfoKey: String {
        switch self {
        case .inserted: return NSInsertedObjectIDsKey
        case .deleted: return NSDeletedObjectIDsKey
        case .updated: return NSUpdatedObjectIDsKey
        }
    }
}

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager()
  
    let container = NSPersistentContainer(name: "Ensemble")
    
    override init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /// Check if notification has a list of UPDATED objects from context
    private func managedObject(with id: NSManagedObjectID, changeType: ChangeType, from notification: Notification, in context: NSManagedObjectContext) -> NSManagedObject? {
        
        guard let objects = notification.userInfo?[changeType.userInfoKey] as? Set<NSManagedObjectID>, objects.contains(id) else {
            return nil
        }
        return context.object(with: id)
    }
    
    /// By utilizing ChangeType, the publisher listens for different kind of changes in the MOC
    func publisher<T: NSManagedObject>(for managedObject: T, in context: NSManagedObjectContext, changeTypes: [ChangeType]) -> AnyPublisher<(T?, ChangeType), Never> {
        
        // Create a notification observer to subscribe to changes in the MOC
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap ({ notification in
                for type in changeTypes {
                    if let object = self.managedObject(with: managedObject.objectID, changeType: type, from: notification, in: context) as? T {
                        return (object, type)
                    }
                }
                return nil
            })
            .eraseToAnyPublisher()
    }
    
    func save() {
        let moc = container.viewContext
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Ensemble operations
    
    func createEnsemble(for name: String) {
        let ensemble = Ensemble(context: container.viewContext)
        ensemble.id = UUID()
        ensemble.name = name
        save()
    }
    
    func createTestEnsemble() -> Ensemble {
        let ensemble = Ensemble(context: container.viewContext)
        ensemble.id = UUID()
        ensemble.name = "Test Ensemble"
        return ensemble
    }
    
    func updateEnsemble(for state: EnsembleEditState) {        
        let piece = fetchEnsemble(for: state.id!)
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
            piece.setValue(compVal, forKeyPath: compProp!)
        }
        save()
    }
    
    func fetchEnsemble(for id: UUID) -> Ensemble {
        let request: NSFetchRequest<Ensemble> = Ensemble.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        var res: [Ensemble] = []
        do {
            res = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching piece: \(error)")
        }
        return res[0]
    }
    
    func getEnsemblesWithCombine() -> Future<[Ensemble], Error> {
        return Future { promise in
            let ensembles = self.ensembles()
            promise(.success(ensembles))
        }
    }
    
    func ensembles() -> [Ensemble] {
        let request: NSFetchRequest<Ensemble> = Ensemble.fetchRequest()
        var fetchedEnsembles: [Ensemble] = []
        
        do {
            fetchedEnsembles = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching ensembles: \(error)")
        }
        
        return fetchedEnsembles
    }
    
    func deleteEnsemble(ensemble: Ensemble) {
        let moc = container.viewContext
        moc.delete(ensemble)
        save()
    }
    
    // MARK: - Piece Operations
    
    func createPiece(for state: CompositionEditState) {
        let piece = Composition(context: container.viewContext)
        let ensemble = state.ensemble!
        piece.id = UUID()
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
            piece.setValue(compVal, forKeyPath: compProp!)
        }
        ensemble.addToPieces(piece)
        save()
    }
    
    func updatePiece(for state: CompositionEditState) {
        // TODO: Implement similar to updatePassage()
        
        let piece = fetchComposition(for: state.id!)
        switch piece {
        case .success(let managedObject):
            if let compositionManagedObject = managedObject {
                let mirror = Mirror(reflecting: state)
                for (compProp, compVal) in mirror.children {
                    compositionManagedObject.setValue(compVal, forKeyPath: compProp!)
                }
				save()
            } else {
                
            }
        case .failure(_):
            print("Couldn't fetch managed object for selected composition")
        }
        
    }
    
    func fetchComposition(for id: UUID) -> Result<Composition?, Error> {
        let request: NSFetchRequest<Composition> = Composition.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let result = try container.viewContext.fetch(request)
            return .success(result.first)
        } catch let error {
            print("Error fetching piece: \(error)")
            return .failure(error)
        }
    }
    
    func pieces(ensemble: Ensemble) -> [Composition] {
        let request: NSFetchRequest<Composition> = Composition.fetchRequest()
        request.predicate = NSPredicate(format: "ensemble = %@", ensemble)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var fetchedPieces: [Composition] = []
        
        do {
            fetchedPieces = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching pieces: \(error)")
        }
        
        return fetchedPieces
    }
    
    func deletePiece(piece: Composition) {
        let moc = container.viewContext
        moc.delete(piece)
        save()
    }
    
    // MARK: Sections Operations
    
    func createPassage(for state: SectionEditState) {
        let section = Passage(context: container.viewContext)
        let piece = state.piece!
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
            section.setValue(compVal, forKeyPath: compProp!)
        }
        piece.addToSection(section)
        save()
    }
    
    func updatePassage(for state: SectionEditState) {
        let section = fetchPassage(for: state.id!)
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
            section.setValue(compVal, forKeyPath: compProp!)
        }
        save()
    }
    
    func fetchPassage(for id: UUID) -> Passage {
        let request: NSFetchRequest<Passage> = Passage.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        var res: [Passage] = []
        do {
            res = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching piece: \(error)")
        }
        return res[0]
    }
    
    func passage(piece: Composition) -> Passage {
        let section = Passage(context: container.viewContext)
        section.id = UUID()
        piece.addToSection(section)
        return section
    }
    
    func passages(for piece: Composition) -> [Passage] {
        let request: NSFetchRequest<Passage> = Passage.fetchRequest()
        request.predicate = NSPredicate(format: "piece = %@", piece)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var fetchedPassages: [Passage] = []
        
        do {
            fetchedPassages = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching pieces: \(error)")
        }
        
        return fetchedPassages
    }
    
    func deletePassage(passage: Passage) {
        let moc = container.viewContext
        moc.delete(passage)
        save()
    }
}
