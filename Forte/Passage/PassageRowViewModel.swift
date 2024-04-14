//
//  PassageRowViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI
import Combine

class PassageRowViewModel: Identifiable, ObservableObject {
	
	@Published private var passage: Passage
	private let dataManager = DataManager.shared
	private var disposables = Set<AnyCancellable>()
	
	@Published var progressValue: String
	
	// NOTE: Needed to prevent the CompositionView ForEach list from creating views infintely
	var id: UUID? {
		return passage.id ?? nil
	}
	
	var name: String {
		return passage.name ?? "unknown section"
	}
	
	var startRehearsalMark: String {
		return passage.startRehearsalMark ?? "??"
	}
	
	var endRehearsalMark: String {
		return passage.endRehearsalMark ?? "??"
	}
	
	var startMeasure: String {
		let measureNum = String(describing: passage.startMeasure)
		return measureNum
	}
	
	var endMeasure: String {
		let measureNum = String(describing: passage.endMeasure)
		return measureNum
	}
	
	init(for passage: Passage) {
		self.passage = passage
		let value = String(describing: Int(passage.progressValue))
		self.progressValue = "\(value)%"
		
		dataManager.passageProgressPublisher
			.filter({ [weak self] (id, _) in
				id == self?.id
			})
			.sink { [weak self] (_, value) in
				self?.progressValue = "\(String(describing: value))%"
			}
			.store(in: &disposables)
	}
	
	func getPassage() -> Passage {
		return self.passage
	}
	
	func deletePassage() {
		dataManager.deletePassage(passage: self.passage)
	}
}
