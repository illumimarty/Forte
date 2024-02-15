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
	@State private var isAddingNewPiece: Bool = false
	@State private var editMode: EditMode = .inactive
	@State private var isEditing: Bool = false
	@State private var showAlert = false
	@State private var selectedItemIndex: Int?
	private var selectedPiece: Composition? {
		guard let idx = selectedItemIndex else { return nil }
		return viewModel.pieces[idx]
	}

    init(for group: Ensemble) {
        self.viewModel = CompositionListViewModel(for: group)
    }
    
    var body: some View {
		ScrollView {
			LazyVStack {
				Text(viewModel.group.name ?? "test")
					.font(.title)
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity, alignment: .leading)
				ForEach(viewModel.pieces.indices, id: \.self) { idx in
					HStack {
						if isEditing {
							Button(role: .destructive) {
								selectedItemIndex = idx
								showAlert.toggle()
							} label: {
								Image(systemName: "minus.circle")
							}
							.padding(4)
						}
						NavigationLink {
							CompositionDetailsView(for: viewModel.pieces[idx])
						} label: {
							CompositionRowView(piece: $viewModel.pieces[idx])
						}
						.buttonStyle(PlainButtonStyle())
						.swipeActions(edge: .leading, allowsFullSwipe: false, content: {
							Button(role: .destructive) {
								let idx = IndexSet(integer: idx)
								viewModel.removePiece(at: idx)
								print("Deleting...")
							} label: {
								Label("Delete", systemImage: "trash.fill")
							}
						})
					}
				}
			}

			.alert(isPresented: $showAlert, content: {
				Alert(
					title: Text("Delete \"\(selectedPiece?.name ?? "")\""),
					message: Text("Are you sure you want to delete this ?"),
					primaryButton: .default(Text("Delete")) {
						if let index = self.selectedItemIndex {
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
				if editMode == .active {
					Button {
						isShowingEditView.toggle()
					} label: {
						Image(systemName: "square.and.pencil")
					}
					.sheet(isPresented: $isShowingEditView, content: {
						EnsembleEditView(for: viewModel.group)
					})
					Button {
						isAddingNewPiece.toggle()
					} label: {
						Image(systemName: "plus.app")
					}
					.sheet(isPresented: $isAddingNewPiece, content: {
						CompositionEditView(group: viewModel.group)
					})
				}
				EditButton().simultaneousGesture(TapGesture().onEnded({ _ in
					isEditing.toggle()
				}))
			}
        }
		.environment(\.editMode, $editMode)
		.eraseToAnyView()
    }
	
    #if DEBUG
    @ObserveInjection var redraw
    #endif
}
