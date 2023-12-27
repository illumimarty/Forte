//
//  EnsembleDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/12/23.
//

import Foundation
import SwiftUI



struct CompositionView: View {
    
    
    @StateObject var viewModel: CompositionListViewModel
    
    @State private var isAuthenticating: Bool = false
    @State private var chosenName = ""
    @State private var isShowingEditView: Bool = false
    
    var body: some View {
        VStack {
            Button("Add") {
                isShowingEditView.toggle()
            }
            .sheet(isPresented: $isShowingEditView) {
//                CompositionEditView(isInitializing: true)
                // CompositionEditView(ensemble: viewModel.ensemble)
    
                let ensemble = viewModel.ensemble
                CompositionEditView(viewModel: CompositionEditViewModel(initialState: CompositionEditState(group: ensemble)))
                
//                CompositionEditView(viewModel: <#T##CompositionListViewModel#>, isInitializing: <#T##Bool#>, ensemble: <#T##Ensemble#>)
            }
            List {
                ForEach(viewModel.pieces, content: { piece in
                    NavigationLink {
                        CompositionDetailsView(passageViewModel: PassageListViewModel(piece: piece), compositionViewModel: self.viewModel)
                    } label: {
                        Text(piece.name ?? "unknown piece")
                    }

                })
                .onDelete(perform: viewModel.removePiece)
            }
            .toolbar {
                EditButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.ensemble.name ?? "unknown").font(.headline)
            }
        }
    }
    
//    func createPiece() {
////        let _ = DataManager.shared.piece(name: chosenName, ensemble: self.ensemble)
//
//        DataManager.shared.save()
//    }
    

}
