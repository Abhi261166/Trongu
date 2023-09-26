//
//  CommentTVCell.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class CommentTVCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var seeReplyView: UIView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnViewReplys: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblSeeReply: UILabel!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var heightConsSeeAllReplys: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
