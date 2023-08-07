//
//  CommentVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class CommentVC: UIViewController {

    @IBOutlet weak var commentTableView: UITableView!
    
    var replyComment = [("Darien","Darien","Same, me too"),("Ellipse 25","Alex","haha sometime i’m lazy to do it")]
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.commentTableView.register(UINib(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        self.commentTableView.register(UINib(nibName: "replyCommentTVCell", bundle: nil), forCellReuseIdentifier: "replyCommentTVCell")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CommentVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return replyComment.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as? CommentTVCell
            else{return UITableViewCell()}
            cell.sepratorView.isHidden = true
            print("CommentTVCell")
            return cell
        } else if indexPath.section == 1 {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "replyCommentTVCell", for: indexPath) as? replyCommentTVCell else{return UITableViewCell()}
            print("replyCommentTVCell")
            cell1.profileImage.image = UIImage(named: replyComment[indexPath.row].0)
            cell1.nameLabel.text = "\(replyComment[indexPath.row].1)"
            cell1.massageLabel.text = "\(replyComment[indexPath.row].2)"
            if indexPath.row == 1{
                cell1.emojiImage.isHidden = true
            }
            return cell1
        }else{
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as? CommentTVCell
            else{return UITableViewCell()}
            print("CommentTVCell")
            cell2.seeReplyView.isHidden = true
            cell2.replyLabel.isHidden = true
            return cell2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
