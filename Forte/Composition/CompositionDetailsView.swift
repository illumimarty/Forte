//
//  CompositionDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import SwiftUI

struct CompositionDetailsView: View {
    
	@ObservedObject var composition: CompositionRowViewModel
    @ObservedObject var viewModel: PassageListViewModel
  
	init(for piece: CompositionRowViewModel, with viewModel: PassageListViewModel) {
		self.viewModel = viewModel
		self.composition = piece
	}
        
    // TODO: Remember to consider the user's groups/pieces since, if multiple users, will pull EVERYONE's data instead of only their own

	var body: some View {
		GeometryReader(content: { geometry in
			ScrollView {
				VStack {
					Text(viewModel.piece.name ?? "test")
						.font(.title)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(viewModel.piece.composer ?? "test")
						.font(.title3)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				.padding(16.0)
				List {
					ForEach(viewModel.passages, content: { section in
						PassageRowView(for: section, mainViewModel: self.viewModel)
					})
					.onDelete(perform: viewModel.removePassage)
				}
				.frame(width: geometry.size.width - 5, height: geometry.size.height - 50, alignment: .center)
				.toolbar {
					ToolbarItemGroup(placement: .topBarTrailing) {
						if viewModel.editMode == .active {
							Button {
								viewModel.isShowingEditView.toggle()
							} label: {
								Image(systemName: "square.and.pencil")
							}
//							.sheet(isPresented: $viewModel.isShowingEditView, content: {
//								CompositionEditView(
//									for: viewModel.piece)
//							})
							Button {
								viewModel.isInitializingSection.toggle()
							} label: {
								Image(systemName: "plus.app")
							}
							//TODO: Implement to change progress value
							.sheet(isPresented: $viewModel.isInitializingSection, content: {
								SectionEditView(piece: viewModel.piece)
									.onDisappear(perform: {
										viewModel.getPassages()
									})
							})
						}
						EditButton()
					}
				}
			}
		})
		.environment(\.editMode, $viewModel.editMode)
		.navigationBarTitleDisplayMode(.inline)
//		.eraseToAnyView()
	}
}

