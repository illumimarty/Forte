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
            }
            List {
				ForEach(viewModel.pieces.indices, id:\.self) { idx in
                    NavigationLink {
						CompositionDetailsView(for: viewModel.pieces[idx])
                    } label: {
						CompositionRowView(piece: $viewModel.pieces[idx])
//						CompositionRowView(pieces: viewModel.piece)
                            .padding(.vertical, 2.0)
                    }
//                    .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
//                        Button(role: .destructive) {
//                            let idx = IndexSet(integer: index)
//                            viewModel.removePiece(at: idx)
//                            print("Deleting...")
//                        } label: {
//                            Label("Delete", systemImage: "trash.fill")
//                        }
//                    })
                    .swipeActions(allowsFullSwipe: false) {
                        NavigationLink {
							CompositionEditView(for: viewModel.pieces[idx], group: viewModel.group)
                                .onDisappear(perform: {
//                                    viewModel.saveData()
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
			.refreshable {
				viewModel.getPieces()
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
//    @ObserveInjection var redraw
//    @ObserveInjection var inject
//    @ObservedObject private var iO = InjectionObserver
    #endif
}
