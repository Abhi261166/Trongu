//
//  MessageTableViewCell.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImgTopCons: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBGView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        let value = UIScreen.main.bounds.width / 2
    //viewTrailingConstraint.constant = value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
