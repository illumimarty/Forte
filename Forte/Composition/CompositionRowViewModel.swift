//
//  CompositionRowViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI
import Combine

class CompositionRowViewModel: Identifiable, ObservableObject {
	
	@Published private var composition: Composition
	private let dataManager = DataManager.shared
	private var disposables = Set<AnyCancellable>()
	@Published public var progressValue: Int
	
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
	
	
	init(for piece: Composition) {
		self.composition = piece
		self.progressValue = dataManager.getProgress(for: piece)
		
		dataManager.compositionProgressPublisher
			.filter({ [weak self] (id, _) in
				id == self?.id
			})
			.sink { [weak self] (_, value) in
				self?.progressValue = value
			}
			.store(in: &disposables)
	}

	func getComposition() -> Composition {
		return self.composition
	}
	
	func delete(_ piece: Composition? = nil) {
		guard piece != nil else {
			dataManager.deletePiece(piece: self.composition)
			return
		}
		dataManager.deletePiece(piece: piece!)
	}
}

extension CompositionRowViewModel: Equatable, Hashable {
	static func == (lhs: CompositionRowViewModel, rhs: CompositionRowViewModel) -> Bool {
		return false
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.composition)
	}
}

extension CompositionRowViewModel {
	var passageView: some View {
		return PassageViewBuilder.makePassageView(for: self)
	}
}
