//
//  MediaTVCell.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit

class MediaTVCell: UITableViewCell {
    
    @IBOutlet weak var playVideoButton: UIButton!
    
    @IBOutlet weak var secondImageView: UIView!
    @IBOutlet weak var secondView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
