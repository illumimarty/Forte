//
//  EnsembleDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/12/23.
//

import Foundation
import SwiftUI


struct EnsembleDetailsView: View {
    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects
    
    let ensemble: Ensemble
    @State private var isAuthenticating = false
    @State private var chosenName = ""
    @State private var isShowingEditView = false
    
    var pieces: [Composition] = []
    
    init(group: Ensemble) {
        ensemble = group 
        pieces = DataManager.shared.pieces(ensemble: group)
    }
    
    var body: some View {
        VStack {
            Button("Add") {
//                isAuthenticating.toggle()
                isShowingEditView.toggle()
            }
//            .alert("Enter group name", isPresented: $isAuthenticating) {
//                TextField("Beethoven 5th Symphony", text: $chosenName)
//                Button("OK", action: createPiece)
//                Button("Cancel", role: .cancel) {}
//            }
            .sheet(isPresented: $isShowingEditView) {
//                CompositionEditView(isInitializing: true)
                CompositionEditView(ensemble: self.ensemble)
            }
            List {
                ForEach(pieces, content: { piece in
                    NavigationLink(destination: CompositionDetailsView(group: ensemble, piece: piece)) {
                            Text(piece.name ?? "unknown piece")
                    }
                })
                .onDelete(perform: removePiece)
            }
            .toolbar {
                EditButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(ensemble.name ?? "unknown").font(.headline)
            }
        }
    }
    
//    func createPiece() {
////        let _ = DataManager.shared.piece(name: chosenName, ensemble: self.ensemble)
//
//        DataManager.shared.save()
//    }
    
    // ? - why delete from a set of indices than one index?
    func removePiece(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        
        for index in offsets {
            let piece = pieces[index]
            DataManager.shared.deletePiece(piece: piece)
        }
    }
}
