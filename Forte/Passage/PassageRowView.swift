//
//  PassageRowView.swift
//  Forte
//
//  Created by Marty Nodado on 4/13/24.
//

import Foundation
import SwiftUI

struct PassageRowView: View {
	
	@ObservedObject private var rowViewModel: PassageRowViewModel
	private var mainViewModel: PassageListViewModel
	
	init(for rowViewModel: PassageRowViewModel, mainViewModel: PassageListViewModel) {
		self.rowViewModel = rowViewModel
		self.mainViewModel = mainViewModel
	}
	//    @ObserveInjection /*var*/ redraw
	
//	var passage: Passage
	//    private var sectionLabelText = {
	//        guard let start = passage.startRehearsalMark,
	//              let end = passage.endRehearsalMark else {
	//            return "?? to ??"
	//        }
	//        return "\(start) to \(end)"
	//    }()
	
//	let percentFormatter: NumberFormatter = {
//		let formatter = NumberFormatter()
//		formatter.numberStyle = .percent
//		formatter.zeroSymbol = ""
//		return formatter
//	}()
	
	var body: some View {
		NavigationLink(destination: SectionEditView(for: rowViewModel.getPassage(), piece: mainViewModel.piece)) {
			HStack {
				VStack {
					Text(rowViewModel.name)
						.frame(maxWidth: .infinity, alignment: .leading)
						.fontWeight(.semibold)
					HStack {
						Text("\(rowViewModel.startRehearsalMark) to \(rowViewModel.endRehearsalMark)")
						//					.frame(maxWidth: 32, alignment: .leading)
						Text("m.\(rowViewModel.startMeasure) to m.\(rowViewModel.endMeasure)")
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				Text(rowViewModel.progressValue)
			}
			.padding(.vertical, 8.0)
		}

//		.eraseToAnyView()
		//        .enableInjection()
	}
	
	#if DEBUG
//		@ObservedObject var iO = injectionObserver
	#endif
}
