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
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Change Password"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveButtonAction))
        makeBorder()
    }

    @objc func saveButtonAction() {
        if oldPasswordTextField.text!.isEmpty || newPasswordTextField.text!.isEmpty || confirmTextField.text!.isEmpty{
            Utils.createAlertWith(message: "Fill in all fields", viewController: self)
        }
        else{
            if newPasswordTextField.text != confirmTextField.text {
                Utils.createAlertWith(message: "New passwords do not match", viewController: self)
            }
            else {
                DownloadData.updateUserPassword(key: currentID, newPassword: newPasswordTextField.text!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }    
    
    //MARK: - Helper Functions
    fileprivate func makeBorder() {
        oldPasswordTextField.layer.borderColor = UIColor.black.cgColor
        oldPasswordTextField.layer.borderWidth = 1
        newPasswordTextField.layer.borderColor = UIColor.black.cgColor
        newPasswordTextField.layer.borderWidth = 1
        confirmTextField.layer.borderColor = UIColor.black.cgColor
        confirmTextField.layer.borderWidth = 1
    }
}
