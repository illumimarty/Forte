//
//  EnsembleDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/12/23.
//

import Foundation
import SwiftUI
import Inject

struct CompositionView: View {
    
//    @ObserveInjection var inject
    @ObservedObject var viewModel: CompositionListViewModel
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
                CompositionEditView(group: viewModel.group)
//                CompositionEditView(for: viewModel.group)
                    .onDisappear(perform: {
                        viewModel.getPieces()
                    })
            }
            List {
                ForEach(Array(viewModel.pieces.enumerated()), id: \.1) { index, piece in
                    NavigationLink {
                        CompositionDetailsView(for: piece)
                        
                    } label: {
                        CompositionRowView(piece: piece)
                            .padding(.vertical, 2.0)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                        Button(role: .destructive) {
                            let idx = IndexSet(integer: index)
                            viewModel.removePiece(at: idx)
                            print("Deleting...")
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    })
                    .swipeActions(allowsFullSwipe: false) {
                        NavigationLink {
                            CompositionEditView(for: piece, group: viewModel.group)
                                .onDisappear(perform: {
                                    viewModel.getPieces()
                                })
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        .tint(.yellow)
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
    }

    #if DEBUG
    @ObserveInjection var redraw
    @ObserveInjection var inject
//    @ObservedObject private var iO = InjectionObserver
    #endif
}
