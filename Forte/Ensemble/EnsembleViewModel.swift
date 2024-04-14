//
//  EnsembleViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 11/21/23.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class EnsembleViewModel: ObservableObject {

    @Published private var dataManager: DataManager
	@Published var chosenName = ""

    @Published var isAuthenticating = false
	@Published var isEditing = false

	@Published var groups: [EnsembleRowViewModel] = []
	
	private var disposables = Set<AnyCancellable>()
	
    
	init(dataManager: DataManager = DataManager.shared, scheduler: DispatchQueue = DispatchQueue(label: "EnsembleViewModel")) {
        self.dataManager = dataManager
		loadEnsembleList()
		
		dataManager.newEnsemblePublisher
			.sink { [weak self] group in
				let newGroupVM = EnsembleRowViewModel(for: group)
				self?.groups.append(newGroupVM)
			}
			.store(in: &disposables)
		
		dataManager.editEnsemblePublisher
			.sink { _ in
				self.loadEnsembleList()
			}
			.store(in: &disposables)
    }
    
    func toggleAuthenticating() {
        isAuthenticating = !isAuthenticating
    }
    
    func createEnsemble() {
        guard !(chosenName.isEmpty) else { return }
        dataManager.createEnsemble(for: chosenName)
        chosenName = ""
    }
    
    func loadEnsembleList() {
        groups = dataManager.ensembles()
    }
}


