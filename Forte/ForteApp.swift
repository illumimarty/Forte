//
//  ForteApp.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import CoreData
@_exported import Inject

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
        
        return true
    }
}

struct ApplicationSwitcher: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        if viewModel.isLoggedIn {
            MainTabView()
        } else {
            ContentView()
        }
    }
}

@main
struct ForteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ApplicationSwitcher()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .onAppear {
                        authViewModel.checkForPreviousSignIn()
                    }
            }
            .environmentObject(authViewModel)
            .environment(\.managedObjectContext, dataManager.container.viewContext)
        }
    }
}
