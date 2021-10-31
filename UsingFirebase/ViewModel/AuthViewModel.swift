//
//  AuthViewModel.swift
//  UsingFirebase
//
//  Created by PHONG on 19/08/2021.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


final class AuthViewModel{
    
    static let shared = AuthViewModel()
    init() {}
    
    var isLogin: Bool {
        
        if UserDefaults.standard.string(forKey: "username") != nil {
            return true
        }else {
            return false
        }
    }
    var fbLoginManager = LoginManager()
    
    let auth = Auth.auth()
    
    func createAccount(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
        }
    }
    
    func login(email: String, password: String, _ com: @escaping (Bool, String?) -> Void){
        auth.signIn(withEmail: email, password: password) { re, error in
            if let error = error {
                com(false, error.localizedDescription)
                return
            }
            
            
            guard let user = self.auth.currentUser else{
                return
            }
            
            UserDefaults.standard.set(user.displayName ?? user.email!, forKey: "username")
            UserDefaults.standard.set(user.uid, forKey: "userID")
            UserDefaults.standard.set(user.photoURL, forKey: "photoUrl")
            com(true, nil)
        }
    }
    
    func checkField(email: String, password: String, repass: String) -> String{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        
        //        let phoneRegEx = "^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$" //Phone of vietnam
        
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if email.isEmpty {
            return "Email is invalid"
        }
        
        if !emailPred.evaluate(with: email) {
            return "The email address is badly formatted"
        }
        
        if password.isEmpty {
            return "Password is invalid"
        }
        
        if (password.count < 6){
            return "Password must greater 6 character"
        }
        
        if email != "" && password != repass{
            return "Password missmath"
        }
        
        return ""
    }
    
    func logout(){
        do {
            try auth.signOut()
            UserDefaults.standard.set(nil, forKey: "username")
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func sighInWithGoogle(viewController: UIViewController, _ com: @escaping (Bool, String?) -> Void){
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [unowned self] user, error in
            
            if let error = error {
                com(false, error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    com(false, error.localizedDescription)
                    return
                }
                
                guard let user = auth.currentUser else{
                    return
                }
                UserDefaults.standard.set(user.displayName ?? user.email!, forKey: "username")
                UserDefaults.standard.set(user.uid, forKey: "userID")
                UserDefaults.standard.set(user.photoURL, forKey: "photoUrl")
         
                com(true, nil)
                
                
            }
            
        }
        
    }
    func signInWithFaceBook() {
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: nil) { res, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let token = AccessToken.current,
               !token.isExpired {
                self.auth.signIn(with: FacebookAuthProvider
                                    .credential(withAccessToken: token.tokenString)) { authResult, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    //                    guard let user = self.auth.currentUser else{
                    //                        return
                    //                    }
                    
                }
            }
        }
    }
    
    func resetPassword(username: String) {
        auth.sendPasswordReset(withEmail: username) { error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                print("We send link reset to email \(username)")
            }
            
        }
    }
    
    
}

