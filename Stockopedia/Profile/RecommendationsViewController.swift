//
//  RecommendationsViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/1/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variables
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var recommendedStocks:[String] = []
    var topics:[(name: String, topic: String)] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Stock Recommendations"
        loadData()
    }
    
    //MARK: - Loading Data
    func loadData() {
        DownloadData.getTopicData(completion: { data in
            self.topics = data!
            self.generateRecommendedStocks()
        })
    }
    
    func generateRecommendedStocks(){
        for topic in topics{
            if topic.topic == button1.titleLabel?.text || topic.topic == button2.titleLabel?.text || topic.topic == button3.titleLabel?.text {
                recommendedStocks.append(topic.name)
            }
        }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return recommendedStocks.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recommendCell") as! RecommendTableViewCell
        cell.nameLabel.text = recommendedStocks[indexPath.row]
        return cell
    }
    
    
    //MARK: - Button Methods
    @IBAction func button1Action(_ sender: UIButton) {
    
    }
    
    @IBAction func button2Action(_ sender: UIButton) {
        
    }
    
    @IBAction func button3Action(_ sender: UIButton) {
        
    }
}
