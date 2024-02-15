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
    
	@State private var editMode: EditMode = .inactive
    @State private var chosenName = ""
    @State private var isShowingEditView: Bool = false
    @State private var isInitializingSection: Bool = false

    var body: some View {
        VStack {
			if editMode == .active {
				Button("Add") {
					isShowingEditView.toggle()
					isInitializingSection.toggle()
				}
				.sheet(isPresented: $isShowingEditView) {
					SectionEditView(piece: passageViewModel.piece)
						.onDisappear(perform: {
							passageViewModel.getPassages()
						})
				}
			}
			GeometryReader(content: { geometry in
				ScrollView {
					VStack {
						Text(passageViewModel.piece.name ?? "test")
							.font(.title)
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(passageViewModel.piece.composer ?? "test")
							.font(.title3)
//							.padding()
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding(16.0)
					List {
						ForEach(passageViewModel.passages, content: { section in
							NavigationLink {
								SectionEditView(for: section, piece: passageViewModel.piece)
							} label: {
								SectionRowView(passage: section)
								//                        Text(section.name ?? "unknown passage")
							}
						})
						.onDelete(perform: passageViewModel.removePassage)
					}
					.frame(width: geometry.size.width - 5, height: geometry.size.height - 50, alignment: .center)
//					.listStyle(.inset)
					.toolbar {
						EditButton()
					}
				}
			})
//            List {
//				VStack {
//					Text(passageViewModel.piece.name ?? "test")
//						.font(.title)
//						.fontWeight(.semibold)
//						.frame(maxWidth: .infinity, alignment: .leading)
//					//					.padding(16.0)
//					Text(passageViewModel.piece.composer ?? "test")
//						.font(.title3)
//						.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
//						.frame(maxWidth: .infinity, alignment: .leading)
//				}
//                ForEach(passageViewModel.passages, content: { section in
//                    NavigationLink {
//                        SectionEditView(for: section, piece: passageViewModel.piece)
//                    } label: {
//                        SectionRowView(passage: section)
////                        Text(section.name ?? "unknown passage")
//                    }
//                })
//                .onDelete(perform: passageViewModel.removePassage)
//                
//            }
//			.listStyle(.inset)
//            .toolbar {
//                EditButton()
//            }
        }
		.environment(\.editMode, $editMode)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text(passageViewModel.piece.name ?? "unknown").font(.headline)
//            }
        }
		.eraseToAnyView()
//		.enableInjection()
		
    }
	#if DEBUG
	@ObservedObject private var iO = injectionObserver
	#endif
}
