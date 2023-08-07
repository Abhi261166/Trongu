//
//  CommentTVCell.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class CommentTVCell: UITableViewCell {
    
    
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var seeReplyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
