//
//  CommentVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit
import GrowingTextView

class CommentVC: UIViewController {

    @IBOutlet weak var txtVwComment: GrowingTextView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    var viewModel:CommentVM?
    var postId:String?
    var isReply = false
    var replyComment = [("Darien","Darien","Same, me too"),("Ellipse 25","Alex","haha sometime i’m lazy to do it")]
    var isOpened = false
    var replyToId = "0"
    var commentId = "0"
    var keyboardHieght : CGFloat?
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        
        print("deinit calles SingleChatController")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewModel()
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.commentTableView.register(UINib(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        self.commentTableView.register(UINib(nibName: "replyCommentTVCell", bundle: nil), forCellReuseIdentifier: "replyCommentTVCell")
        self.commentTableView.register(UINib(nibName: "CommentTableViewHeaderFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "CommentTableViewHeaderFooter")
        txtVwComment.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTable(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    //    MARK: - KeyBoard Methodes -
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Do something with size
            
            self.keyboardHieght = keyboardSize.height
            bottomCons.constant = keyboardSize.height
        }
    }

    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        bottomCons.constant = 0
    }
    
    @objc fileprivate func scrollTable(_ notification: Notification) {
       // self.scrollToBottom(isScrolled: true)
    }
    
    
    func setViewModel(){
        
        self.viewModel = CommentVM(observer: self)
        
    }
    
    func apiCall(){
        self.viewModel?.arrCommentList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiCommentList(postId: postId ?? "")
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSendComment(_ sender: UIButton) {
        disableButtonForHalfSecond()
        let comment = (txtVwComment.text ?? "").trim
        guard comment.count > 0 else { return }
        self.viewModel?.apiSendComment(postId: postId ?? "", comment: comment, replyToId: replyToId, commentId: commentId, isReply: isReply)
    }
    
    func disableButtonForHalfSecond() {
        sendCommentButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.sendCommentButton.isEnabled = true
        }
    }
    
    
}
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
        
        let section = self.viewModel?.arrCommentList[section]
        
        if self.isOpened{
            return (section?.replyComment.count ?? 0) + 1
        }else{
            return 1
        }
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as! CommentTVCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "replyCommentTVCell", for: indexPath) as! replyCommentTVCell
        
        if indexPath.row == 0 {
            
            let dict = self.viewModel?.arrCommentList[indexPath.section]
                 cell.imgProfile.setImage(image: dict?.userImage , placeholder: UIImage(named: "ic_profilePlaceHolder"))
                 cell.lblName.text = dict?.name
                 cell.lblComment.text = dict?.comment
                 let timestamp = Int(dict?.createdAt ?? "") ?? 0
                 let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                 cell.lblTime.text = date.dateToString(format: "hh:mm")
                 cell.lblSeeReply.text = "See Reply (\(dict?.replyCommentCount ?? "0"))"
                 cell.sepratorView.isHidden = true
                 cell.btnViewReplys.tag = indexPath.section
                 cell.btnReply.tag = indexPath.section
                 cell.btnViewReplys.addTarget(self, action: #selector(actionViewReplys),for: .touchUpInside)
                 cell.btnReply.addTarget(self, action: #selector(actionReply),for: .touchUpInside)
            
                if self.isOpened{
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
            cell1.nameLabel.text = dict?.name
            cell1.massageLabel.text = dict?.comment
            let timestamp = Int(dict?.createdAt ?? "") ?? 0
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            cell1.lblTime.text = date.dateToString(format: "hh:mm")
            
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
    
    
    @objc func actionViewReplys(sender:UIButton){
        
        if self.isOpened{
            self.isOpened = false
        }else{
            self.isOpened = true
        }
        commentTableView.beginUpdates()
        commentTableView.reloadSections([sender.tag], with: .none)
        commentTableView.endUpdates()
    }
 
    @objc func actionReply(sender:UIButton){
        self.txtVwComment.becomeFirstResponder()
        self.isReply = true
        self.commentId = self.viewModel?.arrCommentList[sender.tag].commentID ?? ""
        self.replyToId = self.viewModel?.arrCommentList[sender.tag].userID ?? ""
    }
    
}

extension CommentVC:CommentVMObserver{
    func observeAddCommentSucessfull() {
        
        self.txtVwComment.resignFirstResponder()
        self.commentId = "0"
        self.replyToId = "0"
        self.txtVwComment.text = ""
        self.isReply = false
        apiCall()
    }
    
    func observeGetCommentListSucessfull() {
        
        DispatchQueue.main.async {
            self.commentTableView.reloadData()
        } 
   
    }
    
}

extension CommentVC:UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.isReply = false
        self.commentId = "0"
        self.replyToId = "0"
    }
    
}
