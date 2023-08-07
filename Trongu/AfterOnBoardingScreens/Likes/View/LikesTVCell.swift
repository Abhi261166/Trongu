//
//  LikesTVCell.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class LikesTVCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followedByLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followedByView: UIView!
    
    @IBOutlet weak var followWidthCons: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
