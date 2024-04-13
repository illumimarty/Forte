//
//  CompositionListViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import Combine
import SwiftUI


class CompositionListViewModel: ObservableObject {

	@Published private var dataManager: DataManager
	@Published var pieces: [CompositionRowViewModel] = []
	@State var selectedItemIndex: Int?
	@State var isShowingEditView: Bool = false
	@State var isAddingNewPiece: Bool = false
	@State var editMode: EditMode = .inactive
	@State var isEditing: Bool = false
	@State var showAlert = false
	
	var selectedPiece: Composition? {
		get {
			guard let idx = selectedItemIndex else { return nil }
			return self.pieces[idx].getComposition()
		}
		set {
			if let piece = newValue {
				selectedPiece = piece
			}
		}
	}
	
	
	
	//	@Published var pieces: [Composition]
	
	var group: Ensemble
	var anyCancellable: AnyCancellable?
    
    init(for ensemble: Ensemble, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
//        self.pieces = dataManager.pieces(ensemble: ensemble)
        self.group = ensemble
		getPieces()
        
        // TODO: Figure out why this works
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func getPieces() {
        self.pieces = dataManager.pieces(ensemble: group)
    }

    // ? - why delete from a set of indices than one index?
    func removePiece(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        for index in offsets {
            let piece = pieces[index]
			piece.deleteComposition()
//            dataManager.deletePiece(piece: piece)
        }
        pieces.remove(atOffsets: offsets)
    }
}
