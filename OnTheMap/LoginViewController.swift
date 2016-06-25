//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/22/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidLayoutSubviews() {
        gradientView.gradientWithColors(kColorYellowOrange, kColorOrange)
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped(sender: UIButton) {
        print("Email is: \(emailTextField.text)")
        print("Password is: \(passwordTextField.text)")
        login()
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        if let urlForSignup = NSURL(string: UdacityClient.Signup.urlForSignup) {
            UIApplication.sharedApplication().openURL(urlForSignup)
        }
    }
    
    // MARK: - Login
    
    private func login() {
        if let username = emailTextField.text, password = passwordTextField.text {
            
                UdacityClient.logIn(username, password: password) { (success, errorMessage) in
                    if success {
                        self.performSegueWithIdentifier(StoryboardSegue.kSegueToTabBar, sender: self)
                    } else {
                        print(errorMessage)
                    }
                }
        }
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: StoryboardSegue

    private struct StoryboardSegue {
        static let kSegueToTabBar = "segueToTabBar"
    }

}
