//
//  DataManager.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Ensemble")
        container.loadPersistentStores { storeDesc, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
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
    
    func ensemble(name: String) -> Ensemble {
        let ensemble = Ensemble(context: container.viewContext)
        ensemble.id = UUID()
        ensemble.name = name
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
    func piece(ensemble: Ensemble) -> Composition {
        let piece = Composition(context: container.viewContext)
        piece.id = UUID()
        ensemble.addToPieces(piece)
        return piece
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
        let request: NSFetchRequest<Passage> = Passage.fetchRequest()
        request.predicate = NSPredicate(format: "piece = %@", piece)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        var fetchedSections: [Passage] = []
        
        do {
            fetchedSections = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching pieces: \(error)")
        }
        
        return fetchedSections
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
