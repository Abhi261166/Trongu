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
    
    var viewModel:ChatListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        self.messageTableView.register(UINib(nibName: "MessageTVCell", bundle: nil), forCellReuseIdentifier: "MessageTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    
    func setViewModel(){
        
        self.viewModel = ChatListVM(observer: self)
    }
    
    func apiCall(){
        self.viewModel?.page_no = 0
        self.viewModel?.getChatUsersData = []
        self.viewModel?.getChatListApi()
    }
    
}

extension MessageVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getChatUsersData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTVCell", for: indexPath) as! MessageTVCell
        
        let dict = self.viewModel?.getChatUsersData[indexPath.row]
        
        cell.profileImage.setImage(image: dict?.userImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        cell.nameLabel.text = dict?.userName
        cell.messageLabel.text = dict?.lastMessage
        cell.timeLabel.text = dict?.lastMessageTime
        
        if dict?.badgeCount == "0"{
            
            cell.messageCountView.isHidden = true
        }else{
            cell.lblLatestMessageCount.text = dict?.badgeCount
            cell.messageCountView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let chatData = viewModel?.getChatUsersData[indexPath.row]
        
        let vc = ChatVC(roomId: self.viewModel?.getChatUsersData[indexPath.row].roomID ?? "", otherUserName: chatData?.userName ?? "" , otherUserId: self.viewModel?.getChatUsersData[indexPath.row].otherID ?? "" , otherUserProfileImage: chatData?.userImage ?? "")
        
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        
        
    }
    
}

extension MessageVC:ChatListVMObserver{
    
    func observerChatListApi() {
        
        messageTableView.reloadData()
    }
    
}
