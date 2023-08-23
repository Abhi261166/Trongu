//
//  CommentTableViewHeaderFooter.swift
//  Trongu
//
//  Created by apple on 23/08/23.
//

import UIKit

class CommentTableViewHeaderFooter: UITableViewHeaderFooterView {

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
    
    @IBOutlet weak var heightConsSeeAllReplys: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
