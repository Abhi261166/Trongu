//
//  replyCommentTVCell.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class replyCommentTVCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var massageLabel: UILabel!
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnProfileImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
