//
//  ChangeUsernameViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/1/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class ChangeUsernameViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Change Username"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveButtonAction))
        userNameTextField.layer.borderColor = UIColor.black.cgColor
        userNameTextField.layer.borderWidth = 1
    }
    
    @objc func saveButtonAction() {
        if userNameTextField.text!.isEmpty { Utils.createAlertWith(message: "Fill in all fields", viewController: self) }
        else{
            // Update password in SQL
            DownloadData.updateUsername(key: currentUserID, newUsername: userNameTextField.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
