//
//  AuthenticationViewModel.swift
//  Forte
//
//  Created by Marty Nodado on 10/7/23.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

enum UserStateError: Error {
    case signInError, signOutError
}

class AuthenticationViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isBusy = false
    
    func checkForPreviousSignIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
          GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
              guard user != nil else {
                  print(error!.localizedDescription)
                  return
              }
              self.isLoggedIn = true
              print("success!")
            }
        }
    }
    
    func signIn() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard signInResult != nil else {
                print(error!.localizedDescription)
                return
            }
            self.isLoggedIn = true
            print("success?")
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.isLoggedIn = false
    }
}
