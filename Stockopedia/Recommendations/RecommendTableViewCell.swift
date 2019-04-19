//
//  RecommendCellTableViewCell.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/1/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

protocol RecommendTableViewCellDelegate: AnyObject {
    func starTapped(cell: RecommendTableViewCell)
}

class RecommendTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    @IBOutlet weak var abbrLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var favortiesButton: UIButton!
    weak var delegate: RecommendTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func starTapped(sender: AnyObject) {
        delegate?.starTapped(cell: self)
    }

}
