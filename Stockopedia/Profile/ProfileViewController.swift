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
    @IBOutlet var loginView: UIView!
    @IBOutlet var profileView: UIView!
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
        if let id = UserDefaults.standard.string(forKey: "currentID"), let name = UserDefaults.standard.string(forKey: "currentUsername"){
            currentID = id; currentUsername = name
        }
        else { currentID = ""; currentUsername = "" }
        setView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "currentID")
            UserDefaults.standard.removeObject(forKey: "currentUsername")
            currentID = ""
            currentUsername = ""
            self.setView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func setView(){
        if(currentID == "") {
            loginView.isHidden = false
            profileView.isHidden = true
        }else{
            usernameLabel.text = "Logged in as: " + currentUsername
            loginView.isHidden = true
            profileView.isHidden = false
        }
    }
    
    func setUpButtons() {
        changeUserNameButton.layer.borderColor = UIColor.black.cgColor; changeUserNameButton.layer.borderWidth = 1
        changePasswordButton.layer.borderColor = UIColor.black.cgColor; changePasswordButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.black.cgColor; logOutButton.layer.borderWidth = 1
        aboutLabel.layer.borderColor = UIColor.black.cgColor; aboutLabel.layer.borderWidth = 1
    }
}
