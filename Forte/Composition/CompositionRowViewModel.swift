//
//  CompositionRowViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

class CompositionRowViewModel: Identifiable, ObservableObject {
	
	@Published private var composition: Composition
	private let dataManager = DataManager.shared
	
	// NOTE: Needed to prevent the CompositionView ForEach list from creating views infintely
	var id: UUID? {
		return composition.id ?? nil
	}
	
	var name: String {
		return composition.name ?? ""
	}
	
	var composer: String {
		return composition.composer ?? ""
	}
	
//	var progressValue: Int {
//		return composition.
//	}
	
	public var progressValue: Int {
		return DataManager.shared.getProgress(for: self.composition)
	}
	
	init(for piece: Composition) {
		self.composition = piece
	}
	
	func getComposition() -> Composition {
		return self.composition
	}
	
	func deleteComposition() {
		dataManager.deletePiece(piece: self.composition)
	}
}

extension CompositionRowViewModel: Equatable, Hashable {
	static func == (lhs: CompositionRowViewModel, rhs: CompositionRowViewModel) -> Bool {
		return false
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.composition)
	}
	
	//	static func == (lhs: CompositionRowViewModel, rhs: CompositionRowViewModel) -> Bool {
	//		return true
	//	}
	
	
}

extension CompositionRowViewModel {
	var passageView: some View {
		return PassageViewBuilder.makePassageView(for: getComposition())
//		return CompositionViewBuilder.makeCompositionView(for: ensemble)
	}
}
