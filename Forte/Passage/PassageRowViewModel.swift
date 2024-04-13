//
//  PassageRowViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

class PassageRowViewModel: Identifiable, ObservableObject {
	
	@Published private var passage: Passage
	private let dataManager = DataManager.shared
	
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
	
	var progressValue: String {
//		let percentFormatter: NumberFormatter = {
//			let formatter = NumberFormatter()
//			formatter.numberStyle = .percent
//			formatter.zeroSymbol = ""
//			return formatter
//		}()
		
		let value = String(describing: Int(passage.progressValue))
		return "\(value)%"
	}
	
	//	var progressValue: Int {
	//		return composition.
	//	}
	
//	public var progressValue: Int {
//		return DataManager.shared.getProgress(for: self.passage)
//	}
	
	init(for passage: Passage) {
		self.passage = passage
	}
	
	func getPassage() -> Passage {
		return self.passage
	}
	
	func deletePassage() {
		dataManager.deletePassage(passage: self.passage)
	}
}

//extension CompositionRowViewModel: Equatable, Hashable {
//	static func == (lhs: CompositionRowViewModel, rhs: CompositionRowViewModel) -> Bool {
//		return false
//	}
//	
//	func hash(into hasher: inout Hasher) {
//		hasher.combine(self.composition)
//	}
//	
//	//	static func == (lhs: CompositionRowViewModel, rhs: CompositionRowViewModel) -> Bool {
//	//		return true
//	//	}
//	
//	
//}
