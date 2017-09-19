//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Nicholas Sutanto on 9/10/17.
//  Copyright © 2017 Nicholas Sutanto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = OnTheMapTextFieldDelegate.sharedInstance
        passwordTextField.delegate = OnTheMapTextFieldDelegate.sharedInstance
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func performAlert(_ messageString: String) {
        performUIUpdatesOnMain {
            // Login fail
            let alert = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    private func getCurrentUserInfo() {
        
               
        ParseClient.sharedInstance().getStudentInformation(completionHandlerLocation: {(studentInfo, error) in
            
            if (error != nil) {
                self.performAlert("Fail to get user info")
            }
        })
    }

    @IBAction func performLogin(_ sender: Any) {
        if (emailTextField.text! == "" || passwordTextField.text! == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter email and password.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        UdacityClient.sharedInstance().performUdacityLogin(email, password, completionHandlerLogin: { (error) in
            
            if (error == nil) {
                
                // Get User Info
                self.getCurrentUserInfo()
            
                // Complete Login
                self.completeLogin()
            }
            else {
                self.performAlert("Invalid login or password")
            }
        })
    }
    
    @IBAction func performSignUp(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!, options: [:])
        
    }
    
}
