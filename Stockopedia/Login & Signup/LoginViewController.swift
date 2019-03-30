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
        DownloadData.getUser(username: usernameTextField.text!, password: passwordTextField.text!, completion: { user in
            if(user == nil) {
                DispatchQueue.main.async(execute: {
                    Utils.createAlertWith(message: "Username or Password Incorrect", viewController: self)
                })
            }else{
                DispatchQueue.main.async(execute: {
                    UserDefaults.standard.set(user?.key, forKey: "CurrentUser")
                    self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
                })
            }
        })
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
