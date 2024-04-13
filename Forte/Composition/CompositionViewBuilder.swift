//
//  CompositionViewBuilder.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

enum CompositionViewBuilder {
	static func makeCompositionView(for ensemble: Ensemble) -> some View {
		let viewModel = CompositionListViewModel(for: ensemble)
		return CompositionView(with: viewModel)
	}
}
