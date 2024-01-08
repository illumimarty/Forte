//
//  DataManager.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import CoreData

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager()
  
    let container = NSPersistentContainer(name: "Ensemble")
    
    override init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
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
    
    // MARK: Ensemble operations
    
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
    
    // MARK: Piece Operations
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
        section.id = UUID()
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
            section.setValue(compVal, forKeyPath: compProp!)
        }
        piece.addToSection(section)
        save()
    }
    
    func updatePassage(for state: SectionEditState) {

        // Fetch section to update
        let section = fetchPassage(for: state.id!)
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
//            if type(of: <#T##T#>)
            
            section.setValue(compVal, forKeyPath: compProp!)
        }
        save()
        
        // Loop through
        
//        var fetchedPassages: [Passage] = []
//        
//        do {
//            fetchedPassages = try container.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching pieces: \(error)")
//        }
    }
    
    func fetchPassage(for id: UUID) -> Passage {
//        return container.viewContext.existingObject(with: id) as! Passage
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
    
//    func updatePassage(_ section: Passage, for state: SectionEditState) {
//        let mirror = Mirror(reflecting: state)
//        for (compProp, compVal) in mirror.children {
//            section.setValue(compVal, forKeyPath: compProp!)
//        }
////        let section = state.section!
//        save()
//    }
    
//    func fetchPassage(
    
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
