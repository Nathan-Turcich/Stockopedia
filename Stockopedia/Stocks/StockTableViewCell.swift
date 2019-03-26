//
//  StockTableViewCell.swift
//  Stockopedia
//
//  Created by Joey Chung on 3/10/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    //MARK: - Variables
    @IBOutlet var stockNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
