//
//  StockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    //MARK: - Variables
    var stockName:String!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthOneButton: UIButton!
    @IBOutlet weak var monthThreeButton: UIButton!
    @IBOutlet weak var monthSixButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    var buttonArray:[UIButton] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockName
        nameLabel.text = stockName!
        buttonArray = [dayButton, weekButton, monthOneButton, monthThreeButton, monthSixButton, yearButton]
        updateButtons(button: dayButton)
    }
    
    //MARK: - Button Methods
    @IBAction func dayButtonAction(_ sender: UIButton) { updateButtons(button: dayButton) }
    @IBAction func weekButtonAction(_ sender: UIButton) { updateButtons(button: weekButton) }
    @IBAction func monthOneButtonAction(_ sender: UIButton) { updateButtons(button: monthOneButton) }
    @IBAction func monthThreeButtonAction(_ sender: UIButton) { updateButtons(button: monthThreeButton) }
    @IBAction func monthSixButtonAction(_ sender: UIButton) { updateButtons(button: monthSixButton) }
    @IBAction func yearButtonAction(_ sender: UIButton) { updateButtons(button: yearButton) }
    
    func updateButtons(button: UIButton){
        for myButton in buttonArray{
            unselectButton(button: myButton)
        }
        selectButton(button: button)
    }
    
    func selectButton(button: UIButton){
        button.backgroundColor = primaryColor
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func unselectButton(button: UIButton){
        button.backgroundColor = UIColor.white
        button.setTitleColor(primaryColor, for: .normal)
    }
}
