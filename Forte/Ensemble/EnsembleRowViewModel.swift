//
//  EnsembleRowViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

class EnsembleRowViewModel: Identifiable, ObservableObject {
	
	private var ensemble: Ensemble
	private let dataManager = DataManager.shared
	@Published var willDelete = false
	
	var name: String {
		return ensemble.name ?? ""
	}
	
	var location: String {
		return ensemble.location ?? ""
	}
	
	init(for ensemble: Ensemble) {
		self.ensemble = ensemble
	}
	
	func deleteEnsemble() {
		dataManager.deleteEnsemble(ensemble: ensemble)
	}
	
	
}
