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
    @IBOutlet weak var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView? = nil
    
    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 4.0
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator?.color = UIColor.blackColor()
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        gradientView.gradientWithColors(kColorYellowOrange, kColorOrange)
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped(sender: UIButton) {
        print("Email is: \(emailTextField.text)")
        print("Password is: \(passwordTextField.text)")
        
        login()
        configureActivityState(.Active, activityIndicator: activityIndicator!)
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
                            self.alertForError(errorMessage!)
                        }
                        configureActivityState(.Inactive, activityIndicator: self.activityIndicator!)
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
    
    // MARK: - UIKeyboardWillShowNotification
    
    func keyboardWillShow(notification: NSNotification) {
        // If you begin editing the bottomTextField, the view goes up
        if emailTextField.editing || passwordTextField.editing {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // If you end editing the bottomTextField, the view goes back down
        if emailTextField.editing || passwordTextField.editing {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        var keyboardHeight = CGFloat()
        if let userInfo = notification.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            keyboardHeight = keyboardSize.CGRectValue().height
        }
        return keyboardHeight
    }
    
    // MARK: - Alert
    
    private func alertForError(message: String) {
        let alertController = UIAlertController(title: "Login", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
