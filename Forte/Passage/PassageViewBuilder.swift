//
//  PassageViewBuilder.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

enum PassageViewBuilder {
	static func makePassageView(for piece: Composition) -> some View {
		let viewModel = PassageListViewModel(for: piece)
		return CompositionDetailsView(with: viewModel)
	}
//	static func makeCompositionView(for ensemble: Ensemble) -> some View {
//		let viewModel = CompositionListViewModel(for: ensemble)
//		return CompositionView(with: viewModel)
//	}
}
