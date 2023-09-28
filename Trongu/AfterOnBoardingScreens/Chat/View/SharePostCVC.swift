//
//  SharePostCVC.swift
//  Trongu
//
//  Created by apple on 27/09/23.
//

import UIKit

class SharePostCVC: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImgTopCons: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    // related to post
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgPostUserImage: UIImageView!
    @IBOutlet weak var imgPostFirstImage: UIImageView!
    @IBOutlet weak var lblPostDesc: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
}
