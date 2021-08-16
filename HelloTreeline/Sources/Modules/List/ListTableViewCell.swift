//
//  ListTableViewCell.swift
//  HelloTreeline
//
//  Created by raniraja on 8/14/21.
//

import UIKit

protocol ListTableViewCellDelegate:AnyObject {
    func itemIncrement(itemSelectedAt:IndexPath)
    func itemDecrement(itemSelectedAt:IndexPath)
}

class ListTableViewCell: UITableViewCell {

    weak var delegate:ListTableViewCellDelegate?
    var itemSelected:IndexPath?
    
    @IBOutlet weak var itemDecrementBtn: UIButton!
    @IBOutlet weak var itemIncrementBtn: UIButton!
    @IBOutlet weak var itemAvailableLabel: UILabel!
    @IBOutlet weak var itemTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func itemIncrementedSelected(_ sender: UIButton) {
        if let itemSelectedAt = itemSelected {
            self.delegate?.itemIncrement(itemSelectedAt: itemSelectedAt)
        }
    }
    
    @IBAction func itemDecrementSelected(_ sender: UIButton) {
        if let itemSelectedAt = itemSelected {
            self.delegate?.itemDecrement(itemSelectedAt: itemSelectedAt)
        }
    }
}
