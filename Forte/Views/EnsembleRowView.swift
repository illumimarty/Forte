//
//  EnsembleRowView.swift
//  Forte
//
//  Created by Marty Nodado on 1/13/24.
//

import SwiftUI
import HotSwiftUI

struct EnsembleRowView: View {
    
    @ObservedObject var ensemble: Ensemble
	@State private var willDelete = false
	@State private var dataManager = DataManager.shared
	@Binding var isEditing: Bool
    
    var body: some View {
		HStack {
			if isEditing {
				Button(role: .destructive) {
//					selectedItem = group
					willDelete.toggle()
				} label: {
					Image(systemName: "minus.circle")
				}
				.padding(16)
			}
			NavigationLink {
				CompositionView(for: ensemble)
			} label: {
				GroupBox {
					VStack {
						Text(ensemble.name ?? "").font(.title3)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(ensemble.location ?? "")
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
			.buttonStyle(.plain)
		}
		.padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
		.confirmationDialog("Are you sure?", isPresented: $willDelete) {
			Button("OK", role: .destructive) {
				dataManager.deleteEnsemble(ensemble: ensemble)
			}
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("Are you sure you want to delete the group: \(ensemble.name ?? "")?")
		}
        .eraseToAnyView()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}
