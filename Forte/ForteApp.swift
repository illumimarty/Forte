//
//  ForteApp.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct ForteApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(authViewModel: AuthenticationViewModel())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .onAppear {
                        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                                authenticateUser(for: user, with: error)
                            }
                        }
                    }
            }
        }
    }
}
