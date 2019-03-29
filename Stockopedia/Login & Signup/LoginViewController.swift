//
//  LoginViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/28/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Variables
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBorder()
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    fileprivate func makeBorder() {
        usernameTextField.layer.borderColor = UIColor.black.cgColor
        usernameTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 1
    }
}
