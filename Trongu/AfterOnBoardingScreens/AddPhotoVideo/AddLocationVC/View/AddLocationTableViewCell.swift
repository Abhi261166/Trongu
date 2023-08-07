//
//  AddLocationTableViewCell.swift
//  Findr
//
//  Created by apple on 10/04/23.
//

import UIKit

class AddLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shortNameLable: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
