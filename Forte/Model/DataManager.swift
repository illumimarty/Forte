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
        container.loadPersistentStores { desc, error in
//            guard error == nil else { print(error!.localizedDescription)
//                return
//            }
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

//    let container: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Ensemble")
//        container.loadPersistentStores { storeDesc, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
    
    func reload() {
        let moc = container.viewContext
        moc.refreshAllObjects()
    }
    
    func save() {
        let moc = container.viewContext
        if moc.hasChanges {
            do {
                try moc.save()
//                reload()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Ensemble operations
    
//    func ensemble(name: String) -> Ensemble {
//        let ensemble = Ensemble(context: container.viewContext)
//        ensemble.id = UUID()
//        ensemble.name = name
//        return ensemble
//    }
    
    func createEnsemble(for name: String) {
        let ensemble = Ensemble(context: container.viewContext)
        ensemble.id = UUID()
        ensemble.name = name
        save()
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
    func createPiece(for ensemble: Ensemble) -> Composition {
        let piece = Composition(context: container.viewContext)
        piece.id = UUID()
        ensemble.addToPieces(piece)
        save()
        return piece
    }
    
    func createPiece(_ piece: Composition, for ensemble: Ensemble) {
        piece.id = UUID()
        ensemble.addToPieces(piece)
        save()
    }
    
    
    func pieces(ensemble: Ensemble) -> [Composition] {
        let request: NSFetchRequest<Composition> = Composition.fetchRequest()
        request.predicate = NSPredicate(format: "ensemble = %@", ensemble)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
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
    func passage(piece: Composition) -> Passage {
        let section = Passage(context: container.viewContext)
//        section.name = name
        section.id = UUID()
        
        // add following information based on user input
        
        piece.addToSection(section)
        return section
    }
    
    func passages(piece: Composition) -> [Passage] {
//        let request: NSFetchRequest<Passage> = Passage.fetchRequest()
//        request.predicate = NSPredicate(format: "piece = %@", piece)
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
//        var fetchedSections: [Passage] = []
//
//        do {
//            fetchedSections = try container.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching pieces: \(error)")
//        }
//
//        return fetchedSections
        
        let request: NSFetchRequest<Passage> = Passage.fetchRequest()
        request.predicate = NSPredicate(format: "piece = %@", piece)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return (try? container.viewContext.fetch(request)) ?? []
    }
    
    func refreshPassages(for piece: Composition) {
        let _ = passages(piece: piece)
    }
    
    func deletePassage(passage: Passage) {
        let moc = container.viewContext
        moc.delete(passage)
        save()
    }
}

//extension DataManager: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        <#code#>
//    }
//}
