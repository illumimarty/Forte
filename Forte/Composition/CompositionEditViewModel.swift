//
//  CompositionEditViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 12/26/23.
//

import Foundation
import SwiftUI
import Combine

struct CompositionEditState: Equatable {
	var id: UUID?
    var ensemble: Ensemble?
    var name: String = ""
    var composer: String = ""
    var recording_link: String = ""
	
	init(_ piece: Composition?) {
		if let piece = piece {
			self.id = piece.id
			self.ensemble = piece.ensemble
			self.name = piece.name ?? ""
			self.composer = piece.composer ?? ""
			self.recording_link = piece.recording_link ?? ""
		}
	}
    
    init(for group: Ensemble?) {
        if let unwrappedGroup = group {
            self.ensemble = unwrappedGroup
			self.id = UUID()
        }
    }
}

final class CompositionEditViewModel: StateBindingViewModel<CompositionEditState> {

    @Published private var dataManager: DataManager
	@Published var title: String
	internal var isInitializing: Bool = false
    
	init (
		initialState: CompositionEditState,
		dataManager: DataManager = DataManager.shared, isInitializing: Bool = false) {
			self.dataManager = dataManager
			self.isInitializing = isInitializing
			if isInitializing {
				self.title = "New Composition"
			} else {
				self.title = initialState.name
			}
			super.init(initialState: initialState)
			

		}
	
	func updateComposition() {
		dataManager.updatePiece(for: self.state, isInitializing)
	}
	
    func createComposition() {
        dataManager.createPiece(for: self.state)
    }
	
	func saveChanges() {
//		updateComposition()
		if !isInitializing {
			updateComposition()
		} else {
			createComposition()
			
			//            createPassage()
		}
		objectWillChange.send()
	}
}
