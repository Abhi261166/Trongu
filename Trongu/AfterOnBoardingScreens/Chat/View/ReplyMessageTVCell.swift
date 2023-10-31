//
//  ReplyMessageTVCell.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class ReplyMessageTVCell: UITableViewCell {

    //MARK: - IB Outlets -
    @IBOutlet weak var messageBGView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var stackViewBottomCons: NSLayoutConstraint!
    
    //MARK: - LifeCycle Methods -

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
