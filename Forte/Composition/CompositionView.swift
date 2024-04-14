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
					ForEach(viewModel.pieces) { piece in
						CompositionRowView.init(for: piece, mainViewModel: self.viewModel)
					}
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
								EnsembleEditView(for: viewModel.group)
							})
							Button {
								viewModel.isAddingNewPiece.toggle()
							} label: {
								Image(systemName: "plus.app")
							}
							.sheet(isPresented: $viewModel.isAddingNewPiece, content: {
								CompositionEditView(group: viewModel.group)
//								CompositionEditView(for: viewModel.group, isInitializing: true)
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
		.onAppear(perform: {
			viewModel.getPieces()
		})
	}
}
