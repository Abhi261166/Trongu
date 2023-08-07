//
//  ChatVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    var rightcell = ["Hey, How are you.where are you Going","Hi , am  Good."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        self.chatTableView.register(UINib(nibName: "MediaTVCell", bundle: nil), forCellReuseIdentifier: "MediaTVCell")
//        self.chatTableView.register(UINib(nibName: "ReceivePhotoTVCell", bundle: nil), forCellReuseIdentifier: "ReceivePhotoTVCell")
//        self.chatTableView.register(UINib(nibName: "ReplyPhotoTVCell", bundle: nil), forCellReuseIdentifier: "ReplyPhotoTVCell")
//        self.chatTableView.register(UINib(nibName: "ReceiveVideoTVCell", bundle: nil), forCellReuseIdentifier: "ReceiveVideoTVCell")
        
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChatVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch indexPath.row{
//        case 0:
            return 4
//        case 1:
//            return 2
//        default:
//            return 2
//        }
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            switch indexPath.row{
            case 0:

                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
                    else{return UITableViewCell()}
//                cell.messageBGView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius:20, width: cell.messageBGView.bounds.width, height: cell.messageBGView.bounds.height)

                    cell.messageLabel.text = rightcell[indexPath.row]
                    cell.viewLeadingConstraint.constant = 10
                    cell.viewTrailingConstraint.constant = 80
//                     cell.messageBGView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 20, width: cell.messageBGView.layer.bounds.width, height: cell.messageBGView.layer.bounds.height)
                    cell.messageBGView.shadowRadius = 3
                    cell.messageBGView.shadowOpacity = 0.4
                    cell.messageBGView.shadowOffset = CGSize(width: 0, height: 1)
                    cell.messageBGView.shadowColor = .gray
                    print("MessageTableViewCell")
                    return cell
            case 1:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
                    else{return UITableViewCell()}
//                cell.messageBGView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius:20, width: cell.messageBGView.bounds.width, height: cell.messageBGView.bounds.height)
                cell.messageBGView.clipsToBounds = true
                    cell.messageLabel.text = rightcell[indexPath.row]
                    cell.messageLabel.textColor = .white
                    cell.timeLabel.textColor = .white
                cell.profileImgTopCons.constant = 0
                    cell.viewLeadingConstraint.constant = 80
                    cell.viewTrailingConstraint.constant = 20
//                cell.messageBGView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20, width: cell.messageBGView.layer.bounds.width, height: cell.messageBGView.layer.bounds.height)
                    cell.imageWidthConstraint.constant = 0
                    cell.profileImage.isHidden = true
                    cell.headerStackView.isHidden = true
                    cell.messageBGView.backgroundColor = .orange
                    print("MessageTableViewCell")
                    return cell
              
            case 2:
             
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTVCell", for: indexPath) as? MediaTVCell
                    else{return UITableViewCell()}
                cell.playVideoButton.isHidden = true
                    return cell
            case 3:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTVCell", for: indexPath) as? MediaTVCell
                    else{return UITableViewCell()}
                cell.secondImageView.isHidden = true
                cell.secondView.isHidden = true
                    return cell
          
                //        case 2:
                //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivePhotoTVCell", for: indexPath) as? ReceivePhotoTVCell else{return UITableViewCell()}
                //            print("ReceivePhotoTVCell")
                //            return cell
                //
                //        case 3:
                //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyPhotoTVCell", for: indexPath) as? ReplyPhotoTVCell else{return UITableViewCell()}
                //            print("ReplyPhotoTVCell")
                //            return cell
                //
                //        case 4:
                //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveVideoTVCell", for: indexPath) as? ReceiveVideoTVCell else{return UITableViewCell()}
                //            print("ReceiveVideoTVCell")
                //            return cell
                
            default:
                return UITableViewCell()
            }
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        //
        //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        guard let header = UINib(nibName: "HeaderTableViewCell", bundle: nil).instantiate(withOwner: section, options: nil).first as? HeaderTableViewCell else {return UIView()}
        //        return header
        //    }
        //
        //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        return 40
        //    }
    }

//extension UIView{
//
//    func roundCornerss(corners: UIRectCorner, radius: CGFloat, width: CGFloat, height: CGFloat) {
//        let path = UIBezierPath(roundedRect: CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width, height: height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
//}
