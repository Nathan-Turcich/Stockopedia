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
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
