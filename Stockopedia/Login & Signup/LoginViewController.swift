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
                    currentID = user!.ID
                    currentUsername = user!.username
                    UserDefaults.standard.set(currentID, forKey: "currentID")
                    UserDefaults.standard.set(currentUsername, forKey: "currentUsername")
                    self.performSegue(withIdentifier: "fromLoginToMain", sender: self)
                })
            }
        })
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
