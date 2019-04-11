//
//  StockDetailTableViewCell.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/11/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StockDetailTableViewCell: UITableViewCell {

    //MARK: - Variables
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
