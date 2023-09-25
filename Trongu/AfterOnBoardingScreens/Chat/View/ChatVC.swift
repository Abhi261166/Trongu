//
//  ChatVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit
import IQKeyboardManager
import GrowingTextView

class ChatVC: UIViewController {

    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var btnSelectMedia: UIButton!
    
    @IBOutlet weak var txtVwMessage: GrowingTextView!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    var rightcell = ["Hey, How are you.where are you Going","Hi , am  Good."]
    var keyboardHieght : CGFloat?
    var keyboard: KeyboardVM?
    var viewModel:ChatVM?
    var clickedImage:UIImage?
    var click_Image_Data: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtVwMessage.delegate = self
        setViewModel()
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        self.chatTableView.register(UINib(nibName: "MediaTVCell", bundle: nil), forCellReuseIdentifier: "MediaTVCell")
//        self.chatTableView.register(UINib(nibName: "ReceivePhotoTVCell", bundle: nil), forCellReuseIdentifier: "ReceivePhotoTVCell")
//        self.chatTableView.register(UINib(nibName: "ReplyPhotoTVCell", bundle: nil), forCellReuseIdentifier: "ReplyPhotoTVCell")
//        self.chatTableView.register(UINib(nibName: "ReceiveVideoTVCell", bundle: nil), forCellReuseIdentifier: "ReceiveVideoTVCell")
        
    }
    
    func setViewModel(){
        
        self.viewModel = ChatVM(observer: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
      
        keyboard = KeyboardVM()
        keyboard?.setKeyboardNotification(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
      //  self.viewModel?.apiUpdateSeenStatus()
        keyboard?.removeKeyboardNotification()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionSelectMedia(_ sender: UIButton) {
        
        self.viewModel?.imagePicker.mediaType = .both
       // self.viewModel?.imagePicker.selectedAssetIds = self.viewModel?.postImage.map({$0.id ?? ""}) ?? []
       // self.viewModel?.imagePicker.setImagePicker(controller: self, delegate: self)
       
    }
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        
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

extension ChatVC: KeyboardVMObserver {
    
    func keyboard(didChange height: CGFloat, duration: Double, animation: UIView.AnimationOptions) {
        if txtVwMessage.isFirstResponder {
            if bottomCons.constant == height {
                return
            }
        } else {
            if bottomCons.constant == 0 {
                return
            }
        }
        print("height is \(height)")
        self.bottomCons.constant = height
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { finished in
           // self.scrollToBottom(isScrolled: false)
        })
    }
    
    //    MARK: - SCROLL TO Top -
//    func scrollToTop(isScrolled:Bool) {
//        guard isTableScrolled() == false || isScrolled == true  else { return }
//        guard let count = self.viewModel?.arrCommentList.count,
//              count > 0  else { return }
//        let section = 0
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
//            let indexPath = IndexPath(row: 0, section: section)
//            self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
//
//    func isTableScrolled() -> Bool {
//        return (self.commentTableView.contentOffset.y < (self.commentTableView.contentSize.height - SCREEN_SIZE.height))
//    }
    
}

//MARK: - UITextFiled Delegate Methods -
extension ChatVC:UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}


extension ChatVC:ChatVMObserver{
    
    
    
}
