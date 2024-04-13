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
    
    func ensembles() -> [EnsembleRowViewModel] {
        let request: NSFetchRequest<Ensemble> = Ensemble.fetchRequest()
//        var fetchedEnsembles: [Ensemble] = []
        
        do {
            let fetchedEnsembles = try container.viewContext.fetch(request)
			let results = fetchedEnsembles.map(EnsembleRowViewModel.init)
			return results
        } catch let error {
            print("Error fetching ensembles: \(error)")
        }
        
        return []
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
  
	
	func pieces(ensemble: Ensemble) -> [CompositionRowViewModel] {
		let request: NSFetchRequest<Composition> = Composition.fetchRequest()
		request.predicate = NSPredicate(format: "ensemble = %@", ensemble)
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//		var fetchedPieces: [Composition] = []
		
		do {
			let fetchedPieces = try container.viewContext.fetch(request)
			let results = fetchedPieces.map(CompositionRowViewModel.init)
			return results
		} catch let error {
			print("Error fetching pieces: \(error)")
		}
		
		return []
	}
	
	func getProgress(for piece: Composition) -> Int {
		let keypathExp = NSExpression(forKeyPath: "progressValue")
		let expression = NSExpression(forFunction: "average:", arguments: [keypathExp])
		let avgDesc = NSExpressionDescription()
		avgDesc.expression = expression
		avgDesc.name = "avg"
		avgDesc.expressionResultType = .floatAttributeType
		
		let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Passage")
		request.predicate = NSPredicate(format: "piece = %@", piece)
		request.returnsObjectsAsFaults = false
		request.propertiesToFetch = [avgDesc]
		request.resultType = .dictionaryResultType
		
		do {
			let dictionary = try container.viewContext.fetch(request)
			let contents = dictionary[0] as? [String: Any]
			for res in contents! {
				let val = res.value as? Double
				//				piece.setProgress(to: Int(round(val!)))
				//				updatePieceProgress(for: piece, Int(round(val!)))
				return Int(round(val!))
			}
		} catch let error {
			print("Error fetching piece: \(error)")
			return -1
		}
		return -1
	}
	
//    func pieces(ensemble: Ensemble) -> [Composition] {
//        let request: NSFetchRequest<Composition> = Composition.fetchRequest()
//        request.predicate = NSPredicate(format: "ensemble = %@", ensemble)
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        var fetchedPieces: [Composition] = []
//        
//        do {
//            fetchedPieces = try container.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching pieces: \(error)")
//        }
//        
//        return fetchedPieces
//    }
    
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
