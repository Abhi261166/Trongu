//
//  ErrorView.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 30/03/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.//

import UIKit

enum ERROR_TYPE {
    case error
    case success
    case message
    case notification
}


protocol ErrorDelegate {
    func removeErrorView()
}

class ErrorView: UIView {
    
    @IBOutlet var statusIcon: UIImageView!
    @IBOutlet var statusIconBgView: UIView!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var effectView: UIVisualEffectView!
    
    
    var delegate: ErrorDelegate!
    var callBackFromError: ((Bool?) -> Void)?
    var pushData: PushModel?
    
    
    override func awakeFromNib() {
        errorMessage.textColor = UIColor.themeConstrast
        errorMessage.font = UIFont.systemFont(ofSize: 14)
        errorMessage.numberOfLines = 0
        
//        setCustom(.latoRegular, 14)
//        self.statusIcon.image = #imageLiteral(resourceName: "Group 56").withRenderingMode(.alwaysTemplate)
//        self.statusIcon.tintColor = UIColor.white
//        statusIcon.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideErrorMessageWithTap))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func setErrorMessage(message: String, isError: ERROR_TYPE) {
        self.effectView.isHidden = true
        switch isError {
        case .error:
            self.backgroundColor = UIColor.errorColor
        case .success:
            self.backgroundColor = UIColor.successColor
        case .message:
            self.backgroundColor = UIColor.messageColor
        case .notification:
            self.effectView.isHidden = false
            self.backgroundColor = .clear
            self.errorMessage.textColor = .white
        }
        
        self.errorMessage.text = message
        let size = message.heightWithConstrainedWidth(width: SCREEN_SIZE.width-57, font: UIFont.systemFont(ofSize: 14))
        if size.height > 14 {
            self.frame.size.height = (HEIGHT.errorMessageHeight - 13) + size.height
//                + UIApplication.shared.statusBarFrame.height
            self.frame.origin.y = -self.frame.height
        }
        self.showErrorMessage()
    }
    
    func showErrorMessage() {
        var height:CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow == true})
            height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .beginFromCurrentState) {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height + height)
        } completion: { finished in
            self.perform(#selector(self.hideErrorMessageWithoutTap), with: nil, afterDelay: 3.0)
        }
    }
    
    @objc func hideErrorMessageWithTap() {
        if self.pushData != nil {
            self.callBackFromError?(true)
        }
        self.hideErrorMessageWithoutTap()
    }
    
    @objc func hideErrorMessageWithoutTap() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { finished in
            self.delegate.removeErrorView()
        })
    }
    
    func translateToBottom() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -(self.frame.height))
        }, completion: { finished in
            // self.delegate.removeErrorView()
        })
    }
    
    func translateToTop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -(self.frame.height + Singleton.shared.keyboardSize.height))
        }, completion: { finished in
//            self.perform(#selector(self.hideErrorMessage), with: nil, afterDelay: 3.0)
        })
    }
}

class PushModel: NSObject {
    var pushType: PUSH_TYPE?
    var title: String?
    var post_id: String?
    var user_id: String?
    
    var data :[String:Any]?
    var alert:[String:Any]?
    var body:String?
    var creation_date: String?
    var followID: String?
    var message: String?
    var notification_id: String?
    var notification_read_status: String?
    var badge: String?
    var notification_type: String?
    
    
    var otherID: String?
    var photo: String?
    var room_id: String?
    var status_id: String?
    var title_message: String?
    var username: String?
    var viewed_status: String?
    var sound: String?
    
    var json: [String:Any]!
}

typealias JSON = [String:Any]

extension PushModel {
    
    convenience init(json: [String: Any]) {
        self.init()
        self.json = json
        
        if let aps = json["aps"] as? JSON {
            let satus = aps["Status"] as? String ?? ""
            print("satus :- \(satus)")
            if let alert = aps["alert"] as? [String:Any] {
                self.alert = alert
                let body = alert["body"] as? String ?? ""
                self.title = body
                let title = alert["title"] as? String ?? ""
                self.body = title
                print("body :- \(body) title \(title)")
            }
            let badge = aps["badge"] as? String ?? ""
            self.badge = badge
            if let data = aps["data"] as? [String: Any]  {
                self.data = data
                let createdDate = data["creation_date"] as? String ?? ""
                self.creation_date = createdDate
                let followID = data["followID"] as? String ?? ""
                self.followID = followID
                let message = data["message"] as? String ?? ""
                self.message = message
                let notification_id = data["notification_id"] as? String ?? ""
                self.notification_id = notification_id
                let notification_read_status = data["notification_read_status"] as? String ?? ""
                self.notification_read_status = notification_read_status
           
          
                if let notification_type = data["notification_type"] as? Int {
                    self.pushType = PUSH_TYPE(rawValue: notification_type)
                } else if let notification_type = (data["notification_type"] as? String)?.toInt {
                    self.pushType = PUSH_TYPE(rawValue: notification_type)
                }
                print("pushType:- \(self.pushType) ")
                let otherID = data["otherID"] as? String ?? ""
                self.otherID = otherID
                let photo = data["photo"] as? String ?? ""
                self.photo = photo
                let post_id = data["post_id"] as? String ?? ""
                self.post_id = post_id
                let room_id = data["room_id"] as? String ?? ""
                self.room_id = room_id
                let status_id = data["status_id"] as? String ?? ""
                self.status_id = status_id
                let title_message = data["title_message"] as? String ?? ""
                self.title_message = title_message
                let user_id = data["user_id"] as? String ?? ""
                self.user_id = user_id
                let username = data["user_name"] as? String ?? ""
                self.username = username
                let viewed_status = data["viewed_status"] as? String ?? ""
                self.viewed_status = viewed_status
            }
            let sound = aps["sound"] as? String ?? ""
            self.sound = sound
        }
    }
}

enum PUSH_TYPE: Int {
    case following      = 1
    case followRequest  = 2
    case Message        = 6
    case comment_post   = 4
    case like           = 3
}
