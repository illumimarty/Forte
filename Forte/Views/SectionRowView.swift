//
//  SectionRowView.swift
//  Forte
//
//  Created by Marty Nodado on 11/18/23.
//

import Foundation
import SwiftUI
//@_exported import HotSwiftUI
import Inject
@_exported import HotSwiftUI


struct SectionRowView: View {
//    @ObserveInjection /*var*/ redraw

    var passage: Passage
//    private var sectionLabelText = {
//        guard let start = passage.startRehearsalMark,
//              let end = passage.endRehearsalMark else {
//            return "?? to ??"
//        }
//        return "\(start) to \(end)"
//    }()
    
	let percentFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.zeroSymbol = ""
		return formatter
	}()
	
    var body: some View {
		HStack {
			VStack {
				Text(passage.name ?? "unknown section")
					.frame(maxWidth: .infinity, alignment: .leading)
					.fontWeight(.semibold)
				HStack {
					Text("\(passage.startRehearsalMark ?? "??") to \(passage.endRehearsalMark ?? "??")")
					//					.frame(maxWidth: 32, alignment: .leading)
					Text("m.\(String(describing:passage.startMeasure) ?? "??") to m.\(String(describing: passage.endMeasure) ?? "??")")
						.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
			Text("\(Int(passage.progressValue))%")
		}
        .padding(.vertical, 8.0)
        .eraseToAnyView()
//        .enableInjection()
    }
    
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}
