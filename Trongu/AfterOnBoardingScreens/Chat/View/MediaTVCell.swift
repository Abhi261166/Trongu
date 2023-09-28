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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImgTopCons: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imgFirst: UIImageView!
    @IBOutlet weak var lblExtraImagesCount: UILabel!
    @IBOutlet weak var imgFour: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var ForthImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
