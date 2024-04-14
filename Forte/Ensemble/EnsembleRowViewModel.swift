//
//  EnsembleRowViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI
import Combine

class EnsembleRowViewModel: Identifiable, ObservableObject {
	
	private var ensemble: Ensemble
	private let dataManager = DataManager.shared
	private var disposables = Set<AnyCancellable>()
	@Published var willDelete = false
	@Published public var progressValue: Int
	
	var id: UUID? {
		return ensemble.id
	}
	
	var name: String {
		return ensemble.name ?? ""
	}
	
	var location: String {
		return ensemble.location ?? ""
	}
	
	init(for ensemble: Ensemble) {
		self.ensemble = ensemble
		self.progressValue = dataManager.getProgress(for: ensemble)
		
		dataManager.ensembleViewNotifier
//			.filter({ [weak self] (id, _) in
//				id == self?.id
//			})
			.sink { [weak self] _ in
				guard let value = self?.dataManager.getProgress(for: ensemble) else { return }
				self?.progressValue = value
				self?.dataManager.editEnsemblePublisher.send()
			}
			.store(in: &disposables)
	}
	
	func deleteEnsemble() {
		dataManager.deleteEnsemble(ensemble: ensemble)
	}
	
	func getEnsemble() -> Ensemble {
		return ensemble
	}
}

extension EnsembleRowViewModel {
	var compositionView: some View {
		return CompositionViewBuilder.makeCompositionView(for: ensemble)
	}
}
