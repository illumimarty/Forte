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
	@Published var selectedItemIndex: Int?
	@Published var isShowingEditView: Bool = false
	@Published var isAddingNewPiece: Bool = false
	@Published var editMode: EditMode = .inactive
	@Published var isEditing: Bool = false
	@Published var showAlert = false
	@Published var selectedPiece: Composition? = nil
	
	var group: Ensemble
	private var disposables = Set<AnyCancellable>()
    
    init(for ensemble: Ensemble, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.group = ensemble
		getPieces()
        
		dataManager.newCompositionPublisher
			.sink { [weak self] piece in
				let newPieceVM = CompositionRowViewModel(for: piece)
				self?.pieces.append(newPieceVM)
			}
			.store(in: &disposables)
    }
    
    func getPieces() {
        self.pieces = dataManager.pieces(ensemble: group)
    }
}
