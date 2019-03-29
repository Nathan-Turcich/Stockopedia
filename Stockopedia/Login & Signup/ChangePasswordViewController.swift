//
//  ForgotPasswordViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/28/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    //MARK: - Variables
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBorder()
    }

    @IBAction func saveButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Helper Functions
    fileprivate func makeBorder() {
        oldPasswordTextField.layer.borderColor = UIColor.black.cgColor
        oldPasswordTextField.layer.borderWidth = 1
        newPasswordTextField.layer.borderColor = UIColor.black.cgColor
        newPasswordTextField.layer.borderWidth = 1
        confirmTextField.layer.borderColor = UIColor.black.cgColor
        confirmTextField.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 1
    }
}
