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
    
    // current time
    @IBOutlet weak var stackViewTime: UIStackView!
    @IBOutlet weak var stackViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var lblCurrentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    func setDate(currentDate:String?, previousDate:String?){
        if let currentDate = currentDate ,
           let currentTimeStamp = Double(currentDate),
            let previousDate = previousDate,
            let previosTimeStamp = Double(previousDate) {

            let previous = Date(timeIntervalSince1970: previosTimeStamp)
            let current = Date(timeIntervalSince1970: currentTimeStamp)
            let currentDateString = getDateString(date: current)
            let previousDateString = getDateString(date: previous)
            if previousDateString == currentDateString {
                lblCurrentTime.isHidden = true
                stackViewBottomCons.constant = 0
            } else {
                lblCurrentTime.isHidden = false
                stackViewBottomCons.constant = 14.5
                if Calendar.current.isDateInToday(current) == true {
                    lblCurrentTime.text = "Today"
                }else if Calendar.current.isDateInYesterday(current) == true{
                    lblCurrentTime.text = "Yesterday"
                }
                else{
                    lblCurrentTime.text = getDateString(date: current)
                }
                
            }
            
        }else{
            if let currentDate = currentDate ,
               let currentTimeStamp = Double(currentDate){
                let current = Date(timeIntervalSince1970: currentTimeStamp)

                lblCurrentTime.isHidden = false
                stackViewBottomCons.constant = 14.5
                if Calendar.current.isDateInToday(current) == true {
                    lblCurrentTime.text = "Today"
                }else if Calendar.current.isDateInYesterday(current) == true{
                    lblCurrentTime.text = "Yesterday"
                }
                else{
                    lblCurrentTime.text = getDateString(date: current)
                }
//                dateLbl.text = getDateString(date: current)
            }
        }
    }
    
    func getDateString(date:Date)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
        
        
    }
    
    
}
