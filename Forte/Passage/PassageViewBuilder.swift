//
//  PassageViewBuilder.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

enum PassageViewBuilder {
	static func makePassageView(for piece: CompositionRowViewModel) -> some View {
		let viewModel = PassageListViewModel(for: piece.getComposition())
		return CompositionDetailsView(for: piece, with: viewModel)
//		return CompositionRowView(for: piece, mainViewModel: viewModel)
//		return CompositionDetailsView(with: viewModel)
	}
//	static func makeCompositionView(for ensemble: Ensemble) -> some View {
//		let viewModel = CompositionListViewModel(for: ensemble)
//		return CompositionView(with: viewModel)
//	}
}
