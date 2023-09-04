//
//  SettingsTVCell.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit

class SettingsTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgNext: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
