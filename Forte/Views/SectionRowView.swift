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
    
    var body: some View {
        VStack {
            Text(passage.name ?? "unknown section")
            Text("\(passage.startRehearsalMark ?? "??") to \(passage.endRehearsalMark ?? "??")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8.0)
        .eraseToAnyView()
//        .enableInjection()
    }
    
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}
