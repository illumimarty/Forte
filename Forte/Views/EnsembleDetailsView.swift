//
//  EnsembleDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/12/23.
//

import Foundation
import SwiftUI


struct EnsembleDetailsView: View {
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var pieces: FetchedResults<Composition>
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var pieces: FetchedResults<Compo
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var groups: FetchedResults<Ensemble>
    @Environment(\.managedObjectContext) var moc // imoprtant when adding and saving objects
    
    let ensemble: Ensemble
    @State private var isAuthenticating = false
    @State private var chosenName = ""
    
    var pieces: [Composition] = []
//    var pieces: [Composition] = DataManager.shared.pieces(ensemble: ensemble)
    
    init(group: Ensemble) {
        ensemble = group
        pieces = DataManager.shared.pieces(ensemble: group)
    }
    
    var body: some View {
        VStack {
            Button("Add") {
                isAuthenticating.toggle()
            }
            .alert("Enter group name", isPresented: $isAuthenticating) {
                TextField("Beethoven 5th Symphony", text: $chosenName)
                Button("OK", action: createPiece)
                Button("Cancel", role: .cancel) {}
            }
            List {
                ForEach(pieces, content: { piece in
                    Text(piece.name ?? "unknown piece")
                })
//                ForEach(groups) { group in
//                    NavigationLink(destination: EnsembleDetailsView(ensemble: group)) {
//                        Text(group.name ?? "unknown")
//                    }
//                }
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
    
    func createPiece() {
        let _ = DataManager.shared.piece(name: chosenName, ensemble: self.ensemble)
        DataManager.shared.save()
//        let piece = Composition(context: moc)
//        piece.id = UUID()
//        piece.name = chosenName
//        try? moc.save()
    }
    
    // ? - why delete from a set of indices than one index?
    func removePiece(at offsets: IndexSet) {
        // TODO: add a prompt to ensure desired item deletion
        
        for index in offsets {
            let piece = pieces[index]
            DataManager.shared.deletePiece(piece: piece)
        }
//        try? moc.save()
    }
}
