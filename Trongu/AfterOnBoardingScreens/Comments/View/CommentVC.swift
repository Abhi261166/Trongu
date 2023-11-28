//
//  CommentVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit
import GrowingTextView
import IQKeyboardManager

class CommentVC: UIViewController {

    //MARK: - IB Outlets -
    @IBOutlet weak var txtVwComment: GrowingTextView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    //MARK: - Variables -
    var viewModel:CommentVM?
    var postId:String?
    var isReply = false
    var replyComment = [("Darien","Darien","Same, me too"),("Ellipse 25","Alex","haha sometime i’m lazy to do it")]
    var isOpenedSection :[Int] = []
    var isOnlyOneOpened = -1
    var replyToId = "0"
    var commentId = "0"
    var keyboardHieght : CGFloat?
    var keyboard: KeyboardVM?
    
    var completion : (() -> Void)? = nil
    

    //MARK: - LifeCycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewModel()
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.commentTableView.register(UINib(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        self.commentTableView.register(UINib(nibName: "replyCommentTVCell", bundle: nil), forCellReuseIdentifier: "replyCommentTVCell")
        self.commentTableView.register(UINib(nibName: "CommentTableViewHeaderFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "CommentTableViewHeaderFooter")
        txtVwComment.delegate = self

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        apiCall()
        keyboard = KeyboardVM()
        keyboard?.setKeyboardNotification(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
      //  self.viewModel?.apiUpdateSeenStatus()
        keyboard?.removeKeyboardNotification()
    }
    

    
    //MARK: - Coustom Methods -
    
    func setViewModel(){
        self.viewModel = CommentVM(observer: self)
    }
    
    func apiCall(){
       // self.viewModel?.arrCommentList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiCommentList(postId: postId ?? "")
        
    }
    
    func disableButtonForHalfSecond() {
        sendCommentButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.sendCommentButton.isEnabled = true
        }
    }
    
    //MARK: - IB Actions -

    @IBAction func backAction(_ sender: UIButton) {
        
        if let completion = completion{
            popVC()
            completion()
            
        }
        
    }
    
    @IBAction func actionSendComment(_ sender: UIButton) {
        disableButtonForHalfSecond()
        let comment = (txtVwComment.text ?? "").trim
        guard comment.count > 0 else { return }
        self.viewModel?.apiSendComment(postId: postId ?? "", comment: comment, replyToId: replyToId, commentId: commentId, isReply: isReply)
    }
    
}

//MARK: - UITableVew Delegates and DataSource -

extension CommentVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.viewModel?.arrCommentList.count == 0{
            self.commentTableView.setBackgroundView(message: "No comments yet")
            return 0
        }else{
            self.commentTableView.setBackgroundView(message: "")
            return self.viewModel?.arrCommentList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let model = self.viewModel?.arrCommentList[section]
        
        if isOpenedSection.contains(section){
            return (model?.replyComment.count ?? 0) + 1
            
        }else{
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as! CommentTVCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "replyCommentTVCell", for: indexPath) as! replyCommentTVCell
        
        if indexPath.row == 0 {
            
            if indexPath.section == 0{
                cell.sepratorView.isHidden = true
            }else{
                cell.sepratorView.isHidden = false
            }
            
            let dict = self.viewModel?.arrCommentList[indexPath.section]
            cell.imgProfile.setImage(image: dict?.userImage , placeholder: UIImage(named: "ic_profilePlaceHolder"))
            
            cell.btnProfileImage.tag = indexPath.section
            cell.btnProfileImage.addTarget(target: self, action: #selector(imageTapped))
            
            cell.lblName.text = dict?.name
            cell.lblComment.text = dict?.comment
            let timestamp = Int(dict?.createdAt ?? "") ?? 0
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            cell.lblTime.text = date.timeAgoSinceDate()
         
            if dict?.replyCommentCount == "1"{
                cell.lblSeeReply.setAttributed(str1: "See Reply", font1: UIFont.setCustom(.Poppins_Medium, 13), color1: .lightGray, str2:  "(\(dict?.replyCommentCount ?? "0"))", font2: UIFont.setCustom(.Poppins_Medium, 13), color2: .black)
            }else{
                cell.lblSeeReply.setAttributed(str1: "See Replies", font1: UIFont.setCustom(.Poppins_Medium, 13), color1: .lightGray, str2:  "(\(dict?.replyCommentCount ?? "0"))", font2: UIFont.setCustom(.Poppins_Medium, 13), color2: .black)
            }
            
            cell.btnViewReplys.tag = indexPath.section
            cell.btnReply.tag = indexPath.section
            cell.btnViewReplys.addTarget(self, action: #selector(actionViewReplys),for: .touchUpInside)
            cell.btnReply.addTarget(self, action: #selector(actionReply),for: .touchUpInside)
            
            if isOpenedSection.contains(indexPath.section) {
                cell.imgArrow.image = UIImage(named: "ic_upArrow")
            }else{
                cell.imgArrow.image = UIImage(named: "ic_downArrow")
            }
            
            
            if dict?.replyCommentCount == "0"{
                cell.seeReplyView.isHidden = true
                cell.heightConsSeeAllReplys.constant = 0
            }else{
                cell.seeReplyView.isHidden = false
                cell.heightConsSeeAllReplys.constant = 30
            }
            
            return cell
            
        }else{
            let dict = self.viewModel?.arrCommentList[indexPath.section].replyComment[indexPath.row - 1]
            cell1.profileImage.setImage(image: dict?.image , placeholder: UIImage(named: "ic_profilePlaceHolder"))
            
            cell1.btnProfileImage.tag = 1000*indexPath.section + (indexPath.row - 1)
            cell1.btnProfileImage.addTarget(target: self, action: #selector(replyImageTapped))
            
            
            cell1.nameLabel.text = dict?.name
            cell1.massageLabel.text = dict?.comment
            let timestamp = Int(dict?.createdAt ?? "") ?? 0
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            cell1.lblTime.text = date.timeAgoSinceDate()
            
            return cell1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let commentsCount = self.viewModel?.arrCommentList.count else { return }
        if indexPath.row == commentsCount-1 && self.viewModel?.isLastPage == false {
            print("IndexRow\(indexPath.row)")
            self.viewModel?.apiCommentList(postId: self.postId ?? "")
        }
    }
    
    
    //MARK: - Table cell actions -

    @objc func imageTapped(sender: UIButton) {
          // Handle the image tap here
         
          let index = sender.tag
              print("tag value --- ",index)
              
              if self.viewModel?.arrCommentList[index].userID == UserDefaultsCustom.getUserData()?.id{
                  
                  let vc = UserProfileVC()
                  vc.comeFrom = "Comment"
                  vc.hidesBottomBarWhenPushed = true
                  self.pushViewController(vc, true)
                  print("Own Profile")
                  
              }else{
                  let vc = OtherUserProfileVC()
                  vc.userId = self.viewModel?.arrCommentList[index].userID
                  self.pushViewController(vc, true)
              }
              
         
      }
    
    @objc func replyImageTapped(sender: UIButton) {
          // Handle the image tap here
         
          let section = sender.tag / 1000
          let index = sender.tag % 1000
              
              print("tag section value --- ",section)
              print("tag index value --- ",index)
              
              if self.viewModel?.arrCommentList[section].replyComment[index].userID == UserDefaultsCustom.getUserData()?.id{
                  
                  let vc = UserProfileVC()
                  vc.comeFrom = "Comment"
                  vc.hidesBottomBarWhenPushed = true
                  self.pushViewController(vc, true)
                  
                  print("Own Profile")
                  
              }else{
                  let vc = OtherUserProfileVC()
                  vc.userId = self.viewModel?.arrCommentList[index].userID
                  self.pushViewController(vc, true)
              }
              
          
      }
    
    @objc func actionViewReplys(sender:UIButton){
        
        if isOpenedSection.contains(sender.tag){
            if let index = isOpenedSection.firstIndex(of: sender.tag){
                isOpenedSection.remove(at: index)
            }
        }else{
            isOpenedSection.append(sender.tag)
        }
        
        
        /*
         if isOnlyOneOpened == sender.tag{
         isOnlyOneOpened = -1
         }else{
         isOnlyOneOpened = sender.tag
         }
         */
        
        
        DispatchQueue.main.async {
            self.commentTableView.beginUpdates()
            self.commentTableView.reloadSections([sender.tag], with: .none)
            self.commentTableView.endUpdates()
            
            //  self.commentTableView.reloadData()
            
        }
        
        
    }
    
    @objc func actionReply(sender:UIButton){
        self.txtVwComment.becomeFirstResponder()
        self.isReply = true
        self.commentId = self.viewModel?.arrCommentList[sender.tag].commentID ?? ""
        self.replyToId = self.viewModel?.arrCommentList[sender.tag].userID ?? "" // changed
    }
    
    //    MARK: - SCROLL TO Top -
    func scrollToTop(isScrolled:Bool) {
        guard isTableScrolled() == false || isScrolled == true  else { return }
        guard let count = self.viewModel?.arrCommentList.count,
              count > 0  else { return }
        let section = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
            let indexPath = IndexPath(row: 0, section: section)
            self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func isTableScrolled() -> Bool {
        return (self.commentTableView.contentOffset.y < (self.commentTableView.contentSize.height - SCREEN_SIZE.height))
    }
    
}

//MARK: - Api Observers -

extension CommentVC:CommentVMObserver{
    func observeAddCommentSucessfull() {
        self.apiCall()
        
        DispatchQueue.main.async {
            self.txtVwComment.resignFirstResponder()
            self.commentId = "0"
            self.replyToId = "0"
            self.txtVwComment.text = ""
            
        }
        
    }
    
    func observeGetCommentListSucessfull() {
        DispatchQueue.main.async {
            self.commentTableView.reloadData()
            
            if !self.isReply{
                self.scrollToTop(isScrolled: true)
            }
            self.isReply = false
            
        } 
   
    }
    
}

//MARK: - UITextFiled Delegate Methods -
extension CommentVC:UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.isReply = false
        self.commentId = "0"
        self.replyToId = "0"
    }
    
}

extension CommentVC: KeyboardVMObserver {
    
    func keyboard(didChange height: CGFloat, duration: Double, animation: UIView.AnimationOptions) {
        if txtVwComment.isFirstResponder {
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
            //self.scrollToBottom(isScrolled: false)
        })
    }
    
}
