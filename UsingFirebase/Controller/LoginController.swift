//
//  LoginController.swift
//  UsingFirebase
//
//  Created by PHONG on 17/08/2021.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginController: UIViewController {
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var homeVC: UIViewController {
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeController
        homeVC.title = "Chat Chit"
        return homeVC
    }
    
    let spinner = SpinnerViewController()
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginFrame: UIStackView!
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var BtnGoogleLogin: GIDSignInButton!
    
    @IBAction func LoginWithGoogle() {
        
        self.createSpinnerView()
        
        AuthViewModel.shared.sighInWithGoogle(viewController: self) { isLogin, error in
            self.alert(error: error)
            if isLogin {
                self.removeSpinner()
                let navVC = UINavigationController(rootViewController: self.homeVC)
                navVC.navigationBar.prefersLargeTitles = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
        

        
    }
    @IBAction func LoginWithAccount() {
        
        self.createSpinnerView()
        
        guard let username = Username.text else{
            return
        }
        guard let password = Password.text else{
            return
        }
        
        //validate text input
        let errorField = AuthViewModel.shared.checkField(email: username, password: password, repass: password)
        
        if !errorField.isEmpty {
            self.alert(error: errorField)
            self.removeSpinner()
            return
        }
        
        AuthViewModel.shared.login(email: username, password: password) { value, error in

            self.alert(error: error)
            if value{
                self.removeSpinner()
                self.Username.text = ""
                self.Password.text = ""
                let navVC = UINavigationController(rootViewController: self.homeVC)
                navVC.navigationBar.prefersLargeTitles = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
            
        }
        
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LoginButton.layer.cornerRadius = LoginButton.bounds.size.height/2
        LoginFrame.layer.cornerRadius = 10
        self.Password.isSecureTextEntry = true
        
     
    }
    
    func createSpinnerView() {
    
        // add the spinner view controller
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func removeSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    func alert(error: String?){
        guard let error = error else {
            return
        }
        
        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Error",
                                      message: error,
                                      preferredStyle: .alert)
        
        
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default) { (action) in
            self.removeSpinner()
        }
 
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

