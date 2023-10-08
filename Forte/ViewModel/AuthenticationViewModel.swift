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

class AuthenticationViewModel: ObservableObject {

    func handleSignInButton() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let result = signInResult else {
                print(error!.localizedDescription)
                return
            }
            
            print("success!")
        }
    }
}
