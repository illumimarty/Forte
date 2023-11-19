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
    func piece(name: String, ensemble: Ensemble) -> Composition {
        let piece = Composition(context: container.viewContext)
        piece.id = UUID()
        piece.name = name
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
    func section(name: String, piece: Composition) -> Section {
        let section = Section(context: container.viewContext)
        section.name = name
        section.id = UUID()
        
        // add following information based on user input
        
        piece.addToSection(section)
        return section
    }
    
    func sections(piece: Composition) -> [Section] {
        let request: NSFetchRequest<Section> = Section.fetchRequest()
        request.predicate = NSPredicate(format: "piece = %@", piece)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        var fetchedSections: [Section] = []
        
        do {
            fetchedSections = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching pieces: \(error)")
        }
        
        return fetchedSections
    }
    
    func refreshSections(for piece: Composition) {
        let _ = sections(piece: piece)
    }
    
    func deleteSection(section: Section) {
        let moc = container.viewContext
        moc.delete(section)
        save()
    }
}
