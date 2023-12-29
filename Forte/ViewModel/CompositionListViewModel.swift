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

    // TODO: Figure out why this works
    var anyCancellable: AnyCancellable? = nil
    
    init(for ensemble: Ensemble, dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.pieces = dataManager.pieces(ensemble: ensemble)
        self.group = ensemble
        
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
//        // TODO: add a prompt to ensure desired item deletion
//        let pieces = getPieces(for: ensemble)
//        for index in offsets {
//            let piece = pieces[index]
////            let piece = pieces[index]
//            DataManager.shared.deletePiece(piece: piece)
//        }
    }
}
