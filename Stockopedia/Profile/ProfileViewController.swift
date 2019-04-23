//
//  ProfileViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Variables
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var loggedInView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var changeUserNameButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        Utils.getPossibleUser()
        
        if currentID != "" {
            logInView.isHidden = true; logInView.isUserInteractionEnabled = false
            loggedInView.isHidden = false; loggedInView.isUserInteractionEnabled = true
            usernameLabel.text = "Logged in as: " + currentUsername
        }
        else {
            logInView.isHidden = false; logInView.isUserInteractionEnabled = true
            loggedInView.isHidden = true; loggedInView.isUserInteractionEnabled = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "currentID")
            UserDefaults.standard.removeObject(forKey: "currentUsername")
            currentID = ""
            currentUsername = ""
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func setUpButtons() {
        changeUserNameButton.layer.borderColor = UIColor.black.cgColor; changeUserNameButton.layer.borderWidth = 1
        changePasswordButton.layer.borderColor = UIColor.black.cgColor; changePasswordButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.black.cgColor; logOutButton.layer.borderWidth = 1
        aboutLabel.layer.borderColor = UIColor.black.cgColor; aboutLabel.layer.borderWidth = 1
    }
}
