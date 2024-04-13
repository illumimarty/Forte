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
	
	init(with viewModel: CompositionListViewModel) {
		self.viewModel = viewModel
	}
	
	var body: some View {
		GroupBox {
			ScrollView {
				LazyVStack {
					Text(viewModel.group.name ?? "test")
						.font(.title)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity, alignment: .leading)
					ForEach(viewModel.pieces, id: \.id) { piece in
						//					if viewModel.isEditing {
						//						Button(role: .destructive) {
						//							viewModel.selectedPiece = piece.getComposition()
						//							viewModel.showAlert.toggle()
						//						} label: {
						//							Image(systemName: "minus.circle")
						//						}
						//						.padding(4)
						//					}
						//					Text(piece.name)
						CompositionRowView.init(for: piece, mainViewModel: self.viewModel)
					}
					.alert(isPresented: $viewModel.showAlert, content: {
						Alert(
							title: Text("Delete \"\(viewModel.selectedPiece?.name ?? "")\""),
							message: Text("Are you sure you want to delete this ?"),
							primaryButton: .default(Text("Delete")) {
								if let index = viewModel.selectedItemIndex {
									let indexSet = IndexSet(integer: index)
									viewModel.removePiece(at: indexSet)
								}
							},
							secondaryButton: .cancel()
						)
					})
					.padding(24)
				}
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItemGroup(placement: .topBarTrailing) {
						if viewModel.editMode == .active {
							Button {
								viewModel.isShowingEditView.toggle()
							} label: {
								Image(systemName: "square.and.pencil")
							}
							.sheet(isPresented: $viewModel.isShowingEditView, content: {
								//							EnsembleEditView(for: viewModel.group)
							})
							Button {
								viewModel.isAddingNewPiece.toggle()
							} label: {
								Image(systemName: "plus.app")
							}
							.sheet(isPresented: $viewModel.isAddingNewPiece, content: {
								// TODO: Implement
								//							CompositionEditView(group: viewModel.group)
							})
						}
						EditButton().simultaneousGesture(TapGesture().onEnded({ _ in
							viewModel.isEditing.toggle()
						}))
					}
				}
				.environment(\.editMode, $viewModel.editMode)
			}
		}
		
	}
}
