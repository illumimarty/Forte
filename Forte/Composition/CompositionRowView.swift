//
//  CompositionRowView.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

struct CompositionRowView: View {
	
	@ObservedObject private var rowViewModel: CompositionRowViewModel
	private var mainViewModel: CompositionListViewModel
	
	init(for rowVM: CompositionRowViewModel, mainViewModel: CompositionListViewModel) {
		self.rowViewModel = rowVM
		self.mainViewModel = mainViewModel
	}
	
	var body: some View {
		HStack {
			NavigationLink(destination: rowViewModel.passageView) {
				GroupBox {
					HStack {
						VStack {
							Text(rowViewModel.name).font(.title3)
								.frame(maxWidth: .infinity, alignment: .leading)
							
							Text(rowViewModel.composer)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						Text("\(rowViewModel.progressValue)%")
					}
				}
				.padding(.vertical, 4.0)			}
			.buttonStyle(PlainButtonStyle())
			.swipeActions(edge: .leading, allowsFullSwipe: false, content: {
				Button(role: .destructive) {
					rowViewModel.deleteComposition()
					print("Deleting...")
				} label: {
					Label("Delete", systemImage: "trash.fill")
				}
			})
		}
	}
}