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
                CompositionEditView(for: viewModel.group)
            }
            List {
                ForEach(viewModel.pieces) { piece in
                    NavigationLink {
                        
//                        CompositionDetailsView(passageViewModel: PassageListViewModel(piece: piece), compositionViewModel: self.viewModel)
                    } label: {
                        Text(piece.name ?? "unknown piece")
                    }
                }
                .onDelete(perform: viewModel.removePiece)
            }
            .toolbar {
                EditButton()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.group.name ?? "unknown group").font(.headline)
            }
        }
        .onAppear(perform: viewModel.getPieces)
    }
}
