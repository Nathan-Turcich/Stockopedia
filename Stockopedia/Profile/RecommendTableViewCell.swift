//
//  RecommendCellTableViewCell.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/1/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class RecommendTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favortiesButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
