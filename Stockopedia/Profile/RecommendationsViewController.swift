//
//  RecommendationsViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/1/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, RecommendTableViewCellDelegate {
    
    //MARK: - Variables
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var catagory1Label: UILabel!
    @IBOutlet weak var catagory2Label: UILabel!
    @IBOutlet weak var catagory3Label: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecommendationsLabel: UILabel!
    let activityIndicator = UIActivityIndicatorView()
    
    var recommendedStocks:[String] = []
    var topicsTuple:[(name: String, topic: String)] = []
    var topics:[String] = []
    var currentPickerRow:Int = 0
    
    var favoritesList: [String] = []

    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Stock Recommendations"
        loadData()
        tableView.allowsSelection = false
    }
    
    //MARK: - Loading Data
    func loadData() {
        setViewNotLoaded()
        DownloadData.getUserFavoritedList(key: currentUserID, completion: { list  in
            self.favoritesList = list!
            DownloadData.getUserRecommendations(key: currentUserID, completion: { recommendations in
                DownloadData.getTopicData(completion: { data in
                    self.topicsTuple = data!
                    self.generateRecommendedStocks(recommendations: recommendations)
                    self.setViewLoaded()
                })
            })
        })
    }
    
    func generateRecommendedStocks(recommendations: String){
        DispatchQueue.main.async {
            self.topics.removeAll()
            self.recommendedStocks.removeAll()
            for topic in self.topicsTuple {
                    if topic.topic == self.button1.currentTitle || topic.topic == self.button2.currentTitle || topic.topic == self.button3.currentTitle {
                    if !self.recommendedStocks.contains(topic.name){
                        self.recommendedStocks.append(topic.name)
                    }
                }
                self.topics.append(topic.topic)
            }
            self.setTableViewEnabled()
            self.tableView.reloadData()
            self.updateButtons(recommendations: recommendations)
        }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return recommendedStocks.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! RecommendTableViewCell
        cell.nameLabel.text = recommendedStocks[indexPath.row]
        if favoritesList.contains(recommendedStocks[indexPath.row]) {
            cell.favortiesButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)
        }
        else { cell.favortiesButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}
        cell.delegate = self
        return cell
    }
    
    func starTapped(cell: RecommendTableViewCell) {
        if cell.favortiesButton.currentImage == UIImage(named: "favoritesFilled") {
            UIView.transition(with: cell.favortiesButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favortiesButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}, completion: (nil))
            DownloadData.deleteNameFavoritedList(key: currentUserID, name: cell.nameLabel.text!)
        }
        else{
            UIView.transition(with: cell.favortiesButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favortiesButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)}, completion: (nil))
            DownloadData.insertNameFavoritedList(key: currentUserID, name: cell.nameLabel.text!)
        }
    }
    
    //MARK: - PickerView Methods
    @IBAction func buttonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select item from list", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self; pickerView.delegate = self
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let topic = self.topics[self.currentPickerRow]
            if topic == self.button1.titleLabel?.text || topic == self.button2.titleLabel?.text || topic == self.button3.titleLabel?.text {
                Utils.createAlertWith(message: "You already chose this topic.  Choose another", viewController: self)
            }
            else{
                sender.setTitle(self.topics[self.currentPickerRow], for: .normal)
                sender.titleLabel?.adjustsFontSizeToFitWidth = true
                sender.titleLabel?.numberOfLines = 2
                DownloadData.updateUserRecomendations(key: currentUserID, recomendation: self.makeRecommendations(button: sender))
                self.generateRecommendedStocks(recommendations: self.makeRecommendations(button: sender))
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.view.addSubview(pickerView)
        present(alert, animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return topics.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return topics[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { currentPickerRow = row }
    
    //MARK: - Helper Functions
    func setViewLoaded(){
        DispatchQueue.main.async {
            self.button1.isHidden = false; self.button1.isEnabled = true
            self.button2.isHidden = false; self.button2.isEnabled = true
            self.button3.isHidden = false; self.button3.isEnabled = true
            self.tableView.isHidden = false; self.tableView.isScrollEnabled = true
            self.mainLabel.isHidden = false
            self.catagory1Label.isHidden = false; self.catagory2Label.isHidden = false; self.catagory3Label.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    func setViewNotLoaded(){
        button1.isHidden = true; button1.isEnabled = false
        button2.isHidden = true; button2.isEnabled = false
        button3.isHidden = true; button3.isEnabled = false
        tableView.isHidden = true; tableView.isScrollEnabled = false
        mainLabel.isHidden = true
        catagory1Label.isHidden = true; catagory2Label.isHidden = true; catagory3Label.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        activityIndicator.isHidden = false
        view.addSubview(activityIndicator)
        noRecommendationsLabel.isHidden = true
    }
    
    func setTableViewEnabled(){
        if self.recommendedStocks.count == 0 {
            self.noRecommendationsLabel.isHidden = false
            self.tableView.isHidden = true
            self.tableView.separatorStyle = .none
            self.tableView.isScrollEnabled = false
        }
        else {
            self.noRecommendationsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.separatorStyle = .singleLine
            self.tableView.isScrollEnabled = true
        }
    }
    
    func makeRecommendations(button: UIButton) -> String {
        let button1Text = button1.titleLabel?.text!
        let button2Text = button2.titleLabel?.text!
        let button3Text = button3.titleLabel?.text!
        
        if(topics.count > 0) {
            if button == button1 { return topics[currentPickerRow] + "_" + button2Text! + "_" + button3Text!}
            else if button == button2 { return button1Text! + "_" + topics[currentPickerRow] + "_" + button3Text! }
            else { return button1Text! + "_" + button2Text! + "_" + topics[currentPickerRow] }
        }
        
        return "Nil_Nil_Nil"
    }
    
    func updateButtons(recommendations: String){
        let array = recommendations.components(separatedBy: "_")
        
        if(array.count >= 1) {
            button1.setTitle(array[0], for: .normal)
        }
        
        if(array.count >= 2) {
            button2.setTitle(array[1], for: .normal)
        }
        
        if(array.count >= 3) {
            button3.setTitle(array[2], for: .normal)
        }
        
    }
}
