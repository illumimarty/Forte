//
//  EnsembleRowView.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

struct EnsembleRowView: View {
	
	@ObservedObject private var rowViewModel: EnsembleRowViewModel
	@ObservedObject private var mainViewModel: EnsembleViewModel
	
	init(rowViewModel: EnsembleRowViewModel, mainViewModel: EnsembleViewModel) {
		self.rowViewModel = rowViewModel
		self.mainViewModel = mainViewModel
	}
	
	var body: some View {
		HStack {
			if mainViewModel.isEditing {
				Button(role: .destructive) {
					rowViewModel.willDelete.toggle()
				} label: {
					Image(systemName: "minus.circle")
				}
				.padding(16)
			}
			NavigationLink(destination: rowViewModel.compositionView) {
				GroupBox {
					VStack {
						Text(rowViewModel.name).font(.title3)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(rowViewModel.location)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
			.buttonStyle(.plain)
		}
		.padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
		.confirmationDialog("Are you sure?", isPresented: $rowViewModel.willDelete) {
			Button("OK", role: .destructive) {
				rowViewModel.deleteEnsemble()
			}
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("Are you sure you want to delete the group: \(rowViewModel.name ?? "")?")
		}
	}
}

