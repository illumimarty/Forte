//
//  SettingsView.swift
//  Forte
//
//  Created by Marty Nodado on 10/8/23.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Text("SettingsView")
            Button {
                authViewModel.signOut()
            } label: {
                Text("Sign Out")
            }
        }
//        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
