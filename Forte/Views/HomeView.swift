//
//  HomeView.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Home View")
//        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
