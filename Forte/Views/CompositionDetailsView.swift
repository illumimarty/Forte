//
//  CompositionDetailsView.swift
//  Forte
//
//  Created by Marty Nodado on 11/17/23.
//

import Foundation
import SwiftUI
import Inject
import HotSwiftUI

struct CompositionDetailsView: View {
    
    @ObservedObject var passageViewModel: PassageListViewModel
    
    init(for piece: Composition) {
        self.passageViewModel = PassageListViewModel(for: piece)
    }
    
	@State private var isEditing = false
	@State private var editMode: EditMode = .inactive
    @State private var chosenName = ""
    @State private var isShowingEditView: Bool = false
    @State private var isInitializingSection: Bool = false

    var body: some View {
		GeometryReader(content: { geometry in
			ScrollView {
				VStack {
					Text(passageViewModel.piece.name ?? "test")
						.font(.title)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(passageViewModel.piece.composer ?? "test")
						.font(.title3)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				.padding(16.0)
				List {
					ForEach(passageViewModel.passages, content: { section in
						NavigationLink {
							SectionEditView(for: section, piece: passageViewModel.piece)
						} label: {
							SectionRowView(passage: section)
						}
					})
					.onDelete(perform: passageViewModel.removePassage)
				}
				.frame(width: geometry.size.width - 5, height: geometry.size.height - 50, alignment: .center)
				.toolbar {
					ToolbarItemGroup(placement: .topBarTrailing) {
						if editMode == .active {
							Button {
								isShowingEditView.toggle()
							} label: {
								Image(systemName: "square.and.pencil")
							}
							.sheet(isPresented: $isShowingEditView, content: {
								CompositionEditView(
									for: passageViewModel.piece)
							})
							Button {
								isInitializingSection.toggle()
							} label: {
								Image(systemName: "plus.app")
							}
							.sheet(isPresented: $isInitializingSection, content: {
								SectionEditView(piece: passageViewModel.piece)
									.onDisappear(perform: {
										passageViewModel.getPassages()
									})
							})
						}
						EditButton()
					}
				}
			}
		})
		.environment(\.editMode, $editMode)
        .navigationBarTitleDisplayMode(.inline)
		.eraseToAnyView()
    }
	#if DEBUG
	@ObservedObject private var iO = injectionObserver
	#endif
}
