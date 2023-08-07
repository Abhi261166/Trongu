//
//  MessageVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class MessageVC: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    var message = [("MessageImage_3","Rebeka","How,s you ?","08:19 pm"),("MessageImage_4","Manixt ","Hlo","08:10 pm"),("MessageImage_7","Carminia","Hlo","08:02 pm"),("MessageImage_8","Ava","Hlo","07:10 am"),("MessageImage_3","Ploxs","See you then!","07:02 am"),("MessageImage_4","Amelia","Hlo","Yesterday"),("MessageImage_7","Keloai","Hlo","Yesterday"),("MessageImage_8","Sophia","Hlo","Yesterday")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        self.messageTableView.register(UINib(nibName: "MessageTVCell", bundle: nil), forCellReuseIdentifier: "MessageTVCell")
    }
}

extension MessageVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTVCell", for: indexPath) as! MessageTVCell
        cell.profileImage.image = UIImage(named: message[indexPath.row].0)
        cell.nameLabel.text = "\(message[indexPath.row].1)"
        cell.messageLabel.text = "\(message[indexPath.row].2)"
        cell.timeLabel.text = "\(message[indexPath.row].3)"
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 {
            cell.messageCountView.isHidden = false
        }else{
            cell.messageCountView.isHidden = true
        }
        if indexPath.row == 0 || indexPath.row == 1 {
            cell.showOnlineView.isHidden = false
        }else{
            cell.showOnlineView.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
