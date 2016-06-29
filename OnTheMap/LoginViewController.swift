//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eric Sailers on 6/22/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Login state
    
    private enum LoginState { case Inactive, Active }
    
    // MARK: - Properties
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView? = nil
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if activityIndicator != nil {
            configureLoginState(.Inactive)
        }
    }

    override func viewDidLayoutSubviews() {
        gradientView.gradientWithColors(kColorYellowOrange, kColorOrange)
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped(sender: UIButton) {
        print("Email is: \(emailTextField.text)")
        print("Password is: \(passwordTextField.text)")
        login()
        
        if activityIndicator == nil {
            configureLoginState(.Active)
        }
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        if let urlForSignup = NSURL(string: UdacityClient.Signup.urlForSignup) {
            UIApplication.sharedApplication().openURL(urlForSignup)
        }
    }
    
    // MARK: - Login
    
    private func login() {
        if let username = emailTextField.text, password = passwordTextField.text {
            
                UdacityClient.logIn(username, password: password) {
                    (success, errorMessage) in
                    dispatch_async(dispatch_get_main_queue()) {
                        if success {
                            self.performSegueWithIdentifier(StoryboardSegue.kSegueToTabBar, sender: self)
                        } else {
                            if self.activityIndicator != nil {
                                self.configureLoginState(.Inactive)
                            }
                            self.alertForError(errorMessage!)
                        }
                    }
                }
        }
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Configure LoginState
    
    private func configureLoginState(state: LoginState) {
        
        switch state {
        case .Inactive:
            activityIndicator?.hidden = true
            activityIndicator?.stopAnimating()
            activityIndicator = nil
        case .Active:
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            activityIndicator?.center = view.center
            activityIndicator?.hidden = false
            activityIndicator?.startAnimating()
            view.addSubview(activityIndicator!)
        }
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
    
    // MARK: - Alert
    
    private func alertForError(message: String) {
        let alertController = UIAlertController(title: "Login", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
