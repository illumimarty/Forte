//
//  CompositionListViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation

class CompositionListViewModel: ObservableObject {
//    @Published var state: CompositionEditState
    
    @Published var pieces: [Composition] = []
    @Published var ensemble: Ensemble
    
    init(ensemble: Ensemble) {
        self.pieces = DataManager.shared.pieces(ensemble: ensemble)
        self.ensemble = ensemble
    }
    
    

    
    // ? - why delete from a set of indices than one index?
    func removePiece(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        
        for index in offsets {
            let piece = pieces[index]
//            let piece = pieces[index]
            DataManager.shared.deletePiece(piece: piece)
        }
    }
}
