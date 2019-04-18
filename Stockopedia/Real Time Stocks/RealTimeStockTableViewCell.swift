//
//  RealTimeStockTableViewCell.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class RealTimeStockTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    @IBOutlet weak var abbrLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet var buyOrSellLabel: UILabel!
    @IBOutlet var buyOrSellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
