//
//  StockTableViewCell.swift
//  Stockopedia
//
//  Created by Joey Chung on 3/10/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

//1. delegate method
protocol StockCellDelegate: AnyObject {
    func btnCloseTapped(cell: StockTableViewCell)
}

class StockTableViewCell: UITableViewCell {

    //MARK: - Variables
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    weak var delegate: StockCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnCloseTapped(sender: AnyObject) {
        delegate?.btnCloseTapped(cell: self)
    }
}
