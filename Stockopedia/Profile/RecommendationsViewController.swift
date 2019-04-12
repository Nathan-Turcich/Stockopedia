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
    
    var recommendedStocks:[(abbr: String, fullName: String)] = []
    var topicsTuple:[(abbr: String, fullName: String, topic: String)] = []
    var topics:[String] = []
    var currentPickerRow:Int = 0
    var favoritesList: [String] = []

    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Stock Recommendations"
        setButtons()
        loadData()
        tableView.allowsSelection = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let button1Text = button1.titleLabel?.text!
        let button2Text = button2.titleLabel?.text!
        let button3Text = button3.titleLabel?.text!
        DownloadData.updateUserRecomendations(key: currentID, recomendation: button1Text! + "_" + button2Text! + "_" + button3Text!)
    }
    
    //MARK: - Loading Data
    func loadData() {
        setViewNotLoaded()
        DownloadData.downloadUserFavoritedList(key: currentID, completion: { list  in
            for item in list! { self.favoritesList.append(item.abbr)}
            DownloadData.getUserRecommendations(key: currentID, completion: { recommendations in
                DownloadData.getTopicData(completion: { data in
                    self.topicsTuple = data!
                    self.calculateRecommendations(recommendations: recommendations)
                    self.setViewLoaded()
                })
            })
        })
    }
    
    func calculateRecommendations(recommendations: String){
        DispatchQueue.main.async {
            self.topics.removeAll()
            self.recommendedStocks.removeAll()
            self.updateButtons(recommendations: recommendations)
            for topic in self.topicsTuple {
                self.topics.append(topic.topic)
                if topic.topic == self.button1.currentTitle || topic.topic == self.button2.currentTitle || topic.topic == self.button3.currentTitle {
                    if !self.contains(a: self.recommendedStocks, v: (topic.abbr, topic.fullName)) { self.recommendedStocks.append((topic.abbr, topic.fullName)) }
                }
            }
            self.setViewLoaded()
            self.setTableViewEnabled()
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return recommendedStocks.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! RecommendTableViewCell
        cell.abbrLabel.text = recommendedStocks[indexPath.row].abbr
        cell.fullNameLabel.text = recommendedStocks[indexPath.row].fullName
        if favoritesList.contains(recommendedStocks[indexPath.row].abbr) {
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
            DownloadData.deleteNameFavoritedList(key: currentID, abbr: cell.abbrLabel.text!)
        }
        else{
            UIView.transition(with: cell.favortiesButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favortiesButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)}, completion: (nil))
            DownloadData.insertNameFavoritedList(key: currentID, abbr: cell.abbrLabel.text!, fullName: cell.fullNameLabel.text!)
        }
    }
    
    //MARK: - PickerView Methods
    @IBAction func buttonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select item from list", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self; pickerView.delegate = self
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action: UIAlertAction!) in
            sender.setTitle("Choose", for: .normal)
            self.calculateRecommendations(recommendations: self.makeRecommendations(button: sender, text: "Choose"))
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let topic = self.topics[self.currentPickerRow]
            if topic == self.button1.titleLabel?.text || topic == self.button2.titleLabel?.text || topic == self.button3.titleLabel?.text {
                Utils.createAlertWith(message: "You already chose this topic.  Choose another", viewController: self)
            }
            else{
                sender.setTitle(self.topics[self.currentPickerRow], for: .normal)
                self.calculateRecommendations(recommendations: self.makeRecommendations(button: sender, text: self.topics[self.currentPickerRow]))
            }
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
    
    func getRecommendationFromButtons() -> String {
        let button1Text = button1.titleLabel?.text!
        let button2Text = button2.titleLabel?.text!
        let button3Text = button3.titleLabel?.text!
        return button1Text! + "_" + button2Text! + "_" + button3Text!
    }
    
    func makeRecommendations(button: UIButton, text: String) -> String {
        let button1Text = button1.titleLabel?.text!
        let button2Text = button2.titleLabel?.text!
        let button3Text = button3.titleLabel?.text!
        if(topics.count > 0) {
            if button == button1 { return text + "_" + button2Text! + "_" + button3Text!}
            else if button == button2 { return button1Text! + "_" + text + "_" + button3Text! }
            else { return button1Text! + "_" + button2Text! + "_" + text }
        }
        return "Nil_Nil_Nil"
    }
    
    func updateButtons(recommendations: String){
        let array = recommendations.components(separatedBy: "_")
        if(array.count >= 1) { button1.setTitle(array[0].replacingOccurrences(of: "+", with: " "), for: .normal) }
        if(array.count >= 2) { button2.setTitle(array[1].replacingOccurrences(of: "+", with: " "), for: .normal) }
        if(array.count >= 3) { button3.setTitle(array[2].replacingOccurrences(of: "+", with: " "), for: .normal) }
    }
    
    func setButtons(){
        button1.titleLabel?.adjustsFontSizeToFitWidth = true
        button1.titleLabel?.textAlignment = .center
        button1.titleLabel?.numberOfLines = 2
        button2.titleLabel?.adjustsFontSizeToFitWidth = true
        button2.titleLabel?.textAlignment = .center
        button2.titleLabel?.numberOfLines = 2
        button3.titleLabel?.adjustsFontSizeToFitWidth = true
        button3.titleLabel?.textAlignment = .center
        button3.titleLabel?.numberOfLines = 2
    }
    
    func contains(a:[(String, String)], v:(String,String)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
}
