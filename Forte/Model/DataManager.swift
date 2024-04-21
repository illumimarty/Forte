//
//  DataManager.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import CoreData
import Combine

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
    
    
    // MARK: Piece Operations
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
        section.id = UUID()
        
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

protocol ForteState: Equatable {
	var id: UUID? { get }
//	var progressValue: Int16 { get set }
}

protocol ForteFetchable {
	associatedtype ManagedObject: NSManagedObject
	associatedtype ParentObject: Equatable & NSManagedObject
	
	/// Fetches a managed object with the given ID.
	///
	/// - Parameter id: The ID of the object to fetch.
	/// - Returns: The fetched managed object.
	func fetchObject(with id: UUID) -> ManagedObject?
	
	/// Fetches all managed objects associated with the given parent object.
	///
	/// - Parameter parent: The parent object for which to fetch associated objects.
	/// - Returns: An array of fetched managed objects.
	func fetchAll(for parent: ParentObject) -> [ManagedObject]
}

protocol ForteUpdatable {
	func update(for state: any ForteState)
}

protocol Repository {
	associatedtype Object: AnyObject
	associatedtype Parent: AnyObject
	
	func create(obj: Object?, with state: (any ForteState)?)
	func fetch(obj: Object?) -> Object?
	func fetchAll(for parent: Parent?) -> [Object]
	func update(obj: Object?, with state: (any ForteState)?)
	func delete(obj: Object?)
}

class CoreDataRepository<Object: NSManagedObject>: Repository {
	typealias Object = NSManagedObject
	typealias Parent = NSManagedObject
	
	private let dataManager: DataManager
	private let objectType: ForteDataType?
	
	init(dataManager: DataManager = DataManager.shared) {
		self.dataManager = dataManager
		
		switch (Object.self) {
			case is Ensemble.Type: self.objectType = .Ensemble
			case is Composition.Type: self.objectType = .Composition
			case is Passage.Type: self.objectType = .Passage
			default: self.objectType = nil
		}
	}
	
	enum ForteDataType {
		case Ensemble
		case Composition
		case Passage
	}
	
	// TODO: Remove below if above works
	
	private func getKeyForRequest() -> String? {
		switch (objectType) {
			case .Ensemble: return nil
			case .Composition: return "group"
			case .Passage: return "piece"
			default:
				return nil
		}
	}
	
	private func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
		switch objectType {
			case .Ensemble:
				return Ensemble.fetchRequest()
			case .Composition:
				return Composition.fetchRequest()
			case .Passage:
				return Passage.fetchRequest()
			case nil:
				return nil
		}
	}
	
	private func mapStateToObject(_ state: any ForteState, obj: NSManagedObject) {
		let mirror = Mirror(reflecting: state)
		for (compProp, compVal) in mirror.children {
			obj.setValue(compVal, forKeyPath: compProp!)
			if (compProp == "progressValue") {
				guard compVal is Int16 else { continue }
				let input: Int = Int(compVal as! Int16)
//				passageProgressPublisher.send((state.id!, input))
			}
		}
	}
	
	func create(obj: NSManagedObject? = nil, with state: (any ForteState)? = nil) {
		
		if let state = state {
			let stateType = type(of: state)
			switch (stateType) {
				case is CompositionEditState.Type:
					let compositionEditState = state as! CompositionEditState
					let obj = Composition(context: dataManager.container.viewContext)
					let parent = compositionEditState.ensemble!
					mapStateToObject(compositionEditState, obj: obj)
					parent.addToPieces(obj)
					dataManager.save()
				case is SectionEditState.Type:
					let sectionEditState = state as! SectionEditState
					let obj = Passage(context: dataManager.container.viewContext)
					let parent = sectionEditState.piece!
					mapStateToObject(sectionEditState, obj: obj)
					parent.addToSection(obj)
					dataManager.save()
				default:
					return
			}
		}
	}
	
	func fetch(obj: NSManagedObject? = nil) -> NSManagedObject? {
		guard obj != nil else { return nil }
		
		guard let request = createFetchRequest() else { return nil }
		let objectId = obj!.objectID
		request.predicate = NSPredicate(format: "id = %@", objectId)
		var res: [any NSFetchRequestResult]
		
		do {
			res = try dataManager.container.viewContext.fetch(request)
			switch objectType {
				case .Ensemble:
					return res[0] as! Ensemble
				case .Composition:
					return res[0] as! Composition
				case .Passage:
					return res[0] as! Passage
				case nil:
					return nil
			}
		} catch let error {
			print("Error fetching piece: \(error)")
		}
		return nil
//		return res[0] as? NSManagedObject
	}
	
	func fetchAll(for parent: NSManagedObject? = nil) -> [NSManagedObject] {
		
		// Checks if parent object has been passed
		if parent != nil {
			// Check if the caller is of type Ensemble, by which can proceed without a parent
			if objectType != .Ensemble {
				return []
			}
		}
		
		guard let request = createFetchRequest() else { return [] }
		let res: [any NSFetchRequestResult]
		
		if let parentKey = getKeyForRequest() {
			request.predicate = NSPredicate(format: "\(parentKey)", parent!)
			request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		}
		do {
			res = try dataManager.container.viewContext.fetch(request)
			
			switch objectType {
				case .Ensemble:
					return res as! [Ensemble]
				case .Composition:
					return res as! [Composition]
				case .Passage:
					return res as! [Passage]
				case nil:
					return []
			}
		} catch let error {
			print("Error fetching list: \(error)")
		}
		
		return []
	}
	
	func update(obj: NSManagedObject? = nil, with state: (any ForteState)? = nil) {
		if state != nil, 
			let fetchedObject = fetch(obj: obj) {
			mapStateToObject(state!, obj: fetchedObject)
			dataManager.save()
		}
	}
	
	func delete(obj: NSManagedObject? = nil) {
		guard obj != nil else { return }
		dataManager.container.viewContext.delete(obj!)
	}
}

protocol DataServiceProtocol {
	func createEnsemble(for state: EnsembleEditState)
	func fetchEnsemble(obj: Ensemble) -> Ensemble
	func fetchEnsembles() -> [Ensemble]
	func updateEnsemble(for state: EnsembleEditState)
	func deleteEnsemble(obj: Ensemble)
	
	func createComposition(for state: CompositionEditState)
	func fetchComposition(obj: Composition) -> Composition
	func fetchCompositions(for group: Ensemble) -> [Composition]
	func updateComposition(for state: CompositionEditState)
	func deleteComposition(obj: Composition)
	
	func createPassage(for state: SectionEditState)
	func fetchPassage(obj: Passage) -> Passage
	func fetchPassages(for piece: Composition) -> [Passage]
	func updatePassage(for state: SectionEditState)
	func deletePassage(obj: Passage)
}

class DataService: DataServiceProtocol {

	private let ensembleRepository: CoreDataRepository<Ensemble>
	private let compositionRepository: CoreDataRepository<Composition>
	private let passageRepository: CoreDataRepository<Passage>
	private let dataManager: DataManager
	
	init(ensembleRepository: CoreDataRepository<Ensemble>, compositionRepository: CoreDataRepository<Composition>, passageRepository: CoreDataRepository<Passage>, dataManager: DataManager = DataManager.shared) {
		self.ensembleRepository = ensembleRepository
		self.compositionRepository = compositionRepository
		self.passageRepository = passageRepository
		self.dataManager = dataManager
	}
	
	func createEnsemble(for state: EnsembleEditState) {
		ensembleRepository.create(with: state)
	}
	
	func fetchEnsemble(obj: Ensemble) -> Ensemble {
		return ensembleRepository.fetch(obj: obj) as! Ensemble
	}
	
	func fetchEnsembles() -> [Ensemble] {
		return ensembleRepository.fetchAll() as! [Ensemble]
	}
	
	func updateEnsemble(for state: EnsembleEditState) {
		ensembleRepository.update(with: state)
	}
	
	func deleteEnsemble(obj: Ensemble) {
		ensembleRepository.delete(obj: obj)
	}
	
	// MARK: Composition operations
	
	func createComposition(for state: CompositionEditState) {
		compositionRepository.create(with: state)
	}
	
	func fetchComposition(obj: Composition) -> Composition {
		compositionRepository.fetch(obj: obj) as! Composition
	}
	
	func fetchCompositions(for group: Ensemble) -> [Composition] {
		compositionRepository.fetchAll(for: group) as! [Composition]
	}
	
	func updateComposition(for state: CompositionEditState) {
		compositionRepository.update(with: state)
	}
	
	func deleteComposition(obj: Composition) {
		compositionRepository.delete(obj: obj)
	}
	
	// MARK: Passage operations
	
	func createPassage(for state: SectionEditState) {
		passageRepository.create(with: state)
	}
	
	func fetchPassage(obj: Passage) -> Passage {
		return passageRepository.fetch(obj: obj) as! Passage
	}
	
	func fetchPassages(for piece: Composition) -> [Passage] {
		return passageRepository.fetchAll(for: piece) as! [Passage]
	}
	
	func updatePassage(for state: SectionEditState) {
		passageRepository.update(with: state)
	}
	
	func deletePassage(obj: Passage) {
		passageRepository.delete(obj: obj)
	}
}
