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
	
	var valuePublisher = PassthroughSubject<Int, Never>()
	var ensembleProgressPublisher = PassthroughSubject<(UUID, Int), Never>()
	var passageProgressPublisher = PassthroughSubject<(UUID, Int), Never>()
	var compositionProgressPublisher = PassthroughSubject<(UUID, Int), Never>()
	var newCompositionPublisher = PassthroughSubject<Composition, Never>()
	var editCompositionPublisher = PassthroughSubject<Void, Never>()
	var newEnsemblePublisher = PassthroughSubject<Ensemble, Never>()
	var editEnsemblePublisher = PassthroughSubject<Void, Never>()
	var ensembleViewNotifier = PassthroughSubject<Void, Never>()
	
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
		
		newEnsemblePublisher.send(ensemble)
    }
    
    func ensembles() -> [EnsembleRowViewModel] {
        let request: NSFetchRequest<Ensemble> = Ensemble.fetchRequest()
        
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
	
	func updateEnsemble(for state: EnsembleEditState) {
		let section = fetchEnsemble(for: state.id!)
		
		let mirror = Mirror(reflecting: state)
		for (compProp, compVal) in mirror.children {
			section.setValue(compVal, forKeyPath: compProp!)
			if (compProp == "progressValue") {
				guard compVal is Int16 else { continue }
				let input: Int = Int(compVal as! Int16)
				passageProgressPublisher.send((state.id!, input))
			}
		}
		save()
		
		editEnsemblePublisher.send()
		
	}
	
	func getProgress(for group: Ensemble) -> Int {
		let keypathExp = NSExpression(forKeyPath: "progressValue")
		let expression = NSExpression(forFunction: "average:", arguments: [keypathExp])
		let avgDesc = NSExpressionDescription()
		avgDesc.expression = expression
		avgDesc.name = "avg"
		avgDesc.expressionResultType = .floatAttributeType
		
		let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Composition")
		request.predicate = NSPredicate(format: "ensemble = %@", group)
		request.returnsObjectsAsFaults = false
		request.propertiesToFetch = [avgDesc]
		request.resultType = .dictionaryResultType
		
		do {
			let dictionary = try container.viewContext.fetch(request)
			let contents = dictionary[0] as? [String: Any]
			for res in contents! {
				let val = res.value as? Double
				let res = Int(round(val!))
				ensembleProgressPublisher.send((group.id!, res))
				return res
			}
		} catch let error {
			print("Error fetching piece: \(error)")
			return -1
		}
		return -1
	}
    
    // MARK: - Piece Operations
    
    func createPiece(for state: CompositionEditState) {
        let piece = Composition(context: container.viewContext)
        let ensemble = state.ensemble!
		piece.id = state.id!
		
        
        let mirror = Mirror(reflecting: state)
        for (compProp, compVal) in mirror.children {
            piece.setValue(compVal, forKeyPath: compProp!)
        }
        ensemble.addToPieces(piece)
        save()
		
		newCompositionPublisher.send(piece)
		
		
    }
	
	func fetchComposition(for id: UUID) -> Composition {
		let request: NSFetchRequest<Composition> = Composition.fetchRequest()
		request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
		var res: [Composition] = []
		do {
			res = try container.viewContext.fetch(request)
		} catch let error {
			print("Error fetching piece: \(error)")
		}
		return res[0]
	}
	
	func updatePiece(for state: CompositionEditState, _ isInitializing: Bool = false) {
		// TODO: Implement similar to updatePassage()
		
		let piece = fetchComposition(for: state.id!)
		
		let mirror = Mirror(reflecting: state)
		for (compProp, compVal) in mirror.children {
			piece.setValue(compVal, forKeyPath: compProp!)
		}
		save()
		
		if isInitializing {
			newCompositionPublisher.send(piece)
		} else {
			editCompositionPublisher.send()
		}
	}
  
	
	func pieces(ensemble: Ensemble) -> [CompositionRowViewModel] {
		let request: NSFetchRequest<Composition> = Composition.fetchRequest()
		request.predicate = NSPredicate(format: "ensemble = %@", ensemble)
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		
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
				let res = Int(round(val!))
				valuePublisher.send(res)
				return res
			}
		} catch let error {
			print("Error fetching piece: \(error)")
			return -1
		}
		return -1
	}
	
	func updateCompositionProgress(for piece: Composition, to value: Float) {
		let pieceMOC = fetchComposition(for: piece.id!)
		pieceMOC.progressValue = value
//		piece.progressValue = value
		save()
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
	
	func updatePassage(for state: SectionEditState) {
		let section = fetchPassage(for: state.id!)
		
		let mirror = Mirror(reflecting: state)
		for (compProp, compVal) in mirror.children {
			section.setValue(compVal, forKeyPath: compProp!)
			if (compProp == "progressValue") {
				guard compVal is Int16 else { continue }
				let input: Int = Int(compVal as! Int16)
				passageProgressPublisher.send((state.id!, input))
			}
		}
		save()
	}
	
    
    func passage(piece: Composition) -> PassageRowViewModel {
        let section = Passage(context: container.viewContext)
        section.id = UUID()
        piece.addToSection(section)
		
		let viewModel = PassageRowViewModel(for: section)
        return viewModel
    }
  
	func passages(for piece: Composition) -> [PassageRowViewModel] {
		let request: NSFetchRequest<Passage> = Passage.fetchRequest()
		request.predicate = NSPredicate(format: "piece = %@", piece)
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		
		do {
			let fetchedPassages = try container.viewContext.fetch(request)
			let results = fetchedPassages.map(PassageRowViewModel.init)
			return results
		} catch let error {
			print("Error fetching pieces: \(error)")
		}
		
		return []
	}

    func deletePassage(passage: Passage) {
        let moc = container.viewContext
        moc.delete(passage)
        save()
    }
}
