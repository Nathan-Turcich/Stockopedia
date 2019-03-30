//
//  SignUpViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/28/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBorder()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        if(usernameTextField.text != "" && passwordTextField.text != "") {
            DownloadData.createNewUser(username: usernameTextField.text!, password: passwordTextField.text!)
        }
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
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 1
    }
}
