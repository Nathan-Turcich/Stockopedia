//
//  RecommendationsViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/1/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Variables
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var catagory1Label: UILabel!
    @IBOutlet weak var catagory2Label: UILabel!
    @IBOutlet weak var catagory3Label: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    var recommendedStocks:[String] = []
    var topicsTuple:[(name: String, topic: String)] = []
    var topics:[String] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Stock Recommendations"
        loadData()
    }
    
    //MARK: - Loading Data
    func loadData() {
        setViewNotLoaded()
        DownloadData.getTopicData(completion: { data in
            self.topicsTuple = data!
            self.generateRecommendedStocks()
            self.setViewLoaded()
            print("YO")
        })
    }
    
    func generateRecommendedStocks(){
        for topic in topicsTuple {
            if topic.topic == button1.titleLabel?.text || topic.topic == button2.titleLabel?.text || topic.topic == button3.titleLabel?.text {
                recommendedStocks.append(topic.name)
            }
            topics.append(topic.topic)
        }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return recommendedStocks.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! RecommendTableViewCell
        cell.nameLabel.text = recommendedStocks[indexPath.row]
        return cell
    }
    
    
    //MARK: - PickerView Methods
    @IBAction func buttonAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Select item from list",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.view.addSubview(pickerView)
//        alert.present(self, animated: true, completion: nil)
        present(alert, animated: true, completion: nil)
//        present(alertView, animated: true, completion: { _ in
//            pickerView.frame.size.width = alert.view.frame.size.width
//        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return topics.count }
    
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
    }
}
