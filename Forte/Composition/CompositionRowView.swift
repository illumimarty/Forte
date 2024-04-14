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
	@ObservedObject private var mainViewModel: CompositionListViewModel
	
	init(for rowVM: CompositionRowViewModel, mainViewModel: CompositionListViewModel) {
		self.rowViewModel = rowVM
		self.mainViewModel = mainViewModel
	}
	
	var body: some View {
		HStack {
			if mainViewModel.editMode == .active {
				Button(role: .destructive) {
					mainViewModel.selectedPiece = rowViewModel.getComposition()
					mainViewModel.showAlert.toggle()
				} label: {
					Image(systemName: "minus.circle")
				}
				.padding(4)
			}
			
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
		}
		.alert(isPresented: $mainViewModel.showAlert, content: {
			guard let piece = mainViewModel.selectedPiece else {
				return Alert(title: Text("Error"), message: Text("Selected piece is nil"), dismissButton: .default(Text("OK")))

			}
			return Alert(
				title: Text("Delete \"\(piece.name ?? "??")\""),
				message: Text("Are you sure you want to delete this?"),
				primaryButton: .default(Text("Delete")) {
					rowViewModel.delete(piece)
					mainViewModel.getPieces()
				},
				secondaryButton: .cancel()
			)
		})

	}
}
