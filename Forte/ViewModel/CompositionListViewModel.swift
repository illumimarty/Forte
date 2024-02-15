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
	@Published var pieces: [Composition]

    var group: Ensemble
    var anyCancellable: AnyCancellable?
        
    init(for ensemble: Ensemble, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
		self.group = ensemble
        self.pieces = dataManager.pieces(ensemble: ensemble)
        
		anyCancellable = self.dataManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    // TODO: Display overall practice progress of piece
    /*
     1. Fetch request piece
     
     */
    
    func saveData() {
        dataManager.save()
    }
    
    func getPieces() {
        self.pieces = dataManager.pieces(ensemble: group)
    }

    func removePiece(_ piece: Composition) {
        dataManager.deletePiece(piece: piece)
    }
    
    // ? - why delete from a set of indices than one index?
    func removePiece(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        for index in offsets {
            let piece = pieces[index]
            dataManager.deletePiece(piece: piece)
        }
        pieces.remove(atOffsets: offsets)
    }
}
