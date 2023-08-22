//
//  CommentVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit


class CommentVC: UIViewController {

    @IBOutlet weak var commentTableView: UITableView!
    
    var viewModel:CommentVM?
    var postId:String?
    
    var replyComment = [("Darien","Darien","Same, me too"),("Ellipse 25","Alex","haha sometime i’m lazy to do it")]
    var isOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewModel()
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.commentTableView.register(UINib(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        self.commentTableView.register(UINib(nibName: "replyCommentTVCell", bundle: nil), forCellReuseIdentifier: "replyCommentTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    func setViewModel(){
        
        self.viewModel = CommentVM(observer: self)
        
    }
    
    func apiCall(){
        
        self.viewModel?.apiCommentList(postId: postId ?? "")
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as? CommentTVCell
        else{return UITableViewCell()}
        
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "replyCommentTVCell", for: indexPath) as? replyCommentTVCell else{return UITableViewCell()}
        
        if indexPath.row == 0{
            let dict = self.viewModel?.arrCommentList[indexPath.row]
            cell.imgProfile.setImage(image: dict?.userImage , placeholder: UIImage(named: "ic_profilePlaceHolder"))
            cell.lblName.text = dict?.name
            cell.lblComment.text = dict?.comment
            let timestamp = Int(dict?.createdAt ?? "") ?? 0
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            cell.lblTime.text = date.dateToString(format: "hh:mm")
            cell.lblSeeReply.text = "See Reply (\(dict?.replyCommentCount ?? "0"))"
            cell.sepratorView.isHidden = true
          //  cell.btnViewReplys.tag = indexPath
            
            return cell
        } else {
            
            cell1.profileImage.image = UIImage(named: replyComment[indexPath.row].0)
            cell1.nameLabel.text = "\(replyComment[indexPath.row].1)"
            cell1.massageLabel.text = "\(replyComment[indexPath.row].2)"
           
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
}

extension CommentVC:CommentVMObserver{
    
    func observeGetCommentListSucessfull() {
        commentTableView.reloadData()
    }
    
}
