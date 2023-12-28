//
//  EnsembleDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/12/23.
//

import Foundation
import SwiftUI



struct CompositionView: View {
    
    @ObservedObject var viewModel: CompositionListViewModel
//    @Binding var group: Ensemble
//    @Binding var pieces: [Composition]
    
    @State private var isAuthenticating: Bool = false
    @State private var chosenName = ""
    @State private var isShowingEditView: Bool = false
    
    init(for group: Ensemble) {
        self.viewModel = CompositionListViewModel(for: group)
    }
    
    var body: some View {
        VStack {
            Button("Add") {
                isShowingEditView.toggle()
            }
            .sheet(isPresented: $isShowingEditView) {
//                CompositionEditView(isInitializing: true)
                // CompositionEditView(ensemble: viewModel.ensemble)
    
//                let ensemble = $viewModel.ensemble
                CompositionEditView(for: viewModel.group)
//                CompositionEditView(viewModel: CompositionEditViewModel(initialState: CompositionEditState(group: ensemble)))
            }
            List {
                ForEach(viewModel.pieces) { piece in
                    NavigationLink {
                        
//                        CompositionDetailsView(passageViewModel: PassageListViewModel(piece: piece), compositionViewModel: self.viewModel)
                    } label: {
//                        Text(piece.name)
                        Text(piece.name ?? "unknown piece")
                    }
                }
//                ForEach(viewModel.getPieces, content: { piece in
//                    NavigationLink {
//                        CompositionDetailsView(passageViewModel: PassageListViewModel(piece: piece), compositionViewModel: self.viewModel)
//                    } label: {
//                        Text(piece.name ?? "unknown piece")
//                    }
//
//                })
                .onDelete(perform: viewModel.removePiece)
            }
            .onAppear(perform: {
//                self.pieces = DataManager.shared.pieces(ensemble: viewModel.ensemble)
//                self.group = viewModel.ensemble
            })
            .toolbar {
                EditButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("test")
//                Text(viewModel.ensemble.name ?? "unknown").font(.headline)
            }
        }
    }
}
