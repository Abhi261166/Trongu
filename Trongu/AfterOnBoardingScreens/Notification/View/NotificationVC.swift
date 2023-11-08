//
//  NotificationVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

var isfromAppDelegates = false

class NotificationVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var notificationTableView: UITableView!
    var notification = [("NotificationImage_1","James Perry, are requested to follow you","4h"),("NotificationImage_2","Kevin Lowe, Started following you","5h"),("NotificationImage_3","Kevin Lowe, Started following you","12h"),("NotificationImage_4","Jasmine Blake, liked your post","13h")]
    
    var boldname = ["James Perry,","Kevin Lowe,","Kevin Lowe,","Jasmine Blake,"]
    
    var following = [" are requested to follow you"," Started following you"," Started following you"," liked your post"]
    var viewModel:NotificationListVM?
    var completion : (() -> Void)? = nil
    var comeFrom = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: "NotificationTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewModel()
        apiCall()
        
        if comeFrom != ""{
            self.viewModel?.apiUpdateSeen(comeFrom: "Yes")
        }
        
    }

    func setViewModel(){
        
        self.viewModel = NotificationListVM(observer: self)
        
    }
    
    func apiCall(){
        self.viewModel?.arrNotificationList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiNotificationList()
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        disableButtonForHalfSecond()
        if let completion = completion{
            
            self.viewModel?.apiUpdateSeen(comeFrom: "No")
            completion()
        }
        
    }
    
    func disableButtonForHalfSecond() {
        btnBack.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.btnBack.isEnabled = true
        }
    }
   
}
extension NotificationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel?.arrNotificationList.count ?? 0 == 0 {
            self.notificationTableView.setBackgroundView(message: "No notification listing")
            return 0
        }else{
            self.notificationTableView.setBackgroundView(message: "")
            return self.viewModel?.arrNotificationList.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        let dict = self.viewModel?.arrNotificationList[indexPath.row]
        
        cell.profileImage.setImage(image: dict?.userImage,placeholder: UIImage(named: "ic_profilePlaceHolder"))
      //  cell.nameLabel.text = dict?.userName
        let timestamp = Int(dict?.createdAt ?? "") ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        cell.timeLabel.text = date.timeAgoSinceDate()
        cell.nameLabel.setAttributed(str1: "\(dict?.userName ?? "")", font1: UIFont.setCustom(.Poppins_Medium, 16), color1: .black, str2: "\(dict?.notification ?? "")", font2: UIFont.setCustom(.Poppins_Regular, 16), color2: .gray)
        if dict?.notificationType == "1"{
            if dict?.requestStatuss == "requested"{
                cell.buttonStackView.isHidden = false
                cell.stackViewHeightConst.constant = 30
                cell.btnAccept.tag = indexPath.row
                cell.btnReject.tag = indexPath.row
                cell.btnReject.addTarget(target: self, action: #selector(actionReject))
                cell.btnAccept.addTarget(target: self, action: #selector(actionAccept))
            }else{
                cell.buttonStackView.isHidden = true
                cell.stackViewHeightConst.constant = 0
            }
            
        }
        else{
            cell.buttonStackView.isHidden = true
            cell.stackViewHeightConst.constant = 10
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1=>follow 2=>following 3=>like 4=>comment 5=>mass push 6=>send message
        let dict = self.viewModel?.arrNotificationList[indexPath.row]
        
        switch dict?.notificationType {
        case "1":
            let vc = OtherUserProfileVC()
            vc.userId = dict?.userID
            vc.hidesBottomBarWhenPushed = true
            pushViewController(vc, true)
        case "2":
            let vc = OtherUserProfileVC()
            vc.userId = dict?.userID
            vc.hidesBottomBarWhenPushed = true
            pushViewController(vc, true)
        case "3":
                let vc = DetailVC()
                vc.completion = {}
                vc.postId = dict?.postID
                vc.hidesBottomBarWhenPushed = true
                pushViewController(vc, true)
        case "4":
                let vc = DetailVC()
                vc.completion = {}
                vc.postId = dict?.postID
                vc.hidesBottomBarWhenPushed = true
                pushViewController(vc, true)
        default:
            break
        }
        
    }
    
    
//    let vc = DetailVC()
//    vc.comeFrom = "Push"
//    vc.postId = pushData.post_id
//    vc.hidesBottomBarWhenPushed = true
//    viewController?.pushViewController(vc, true)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func actionReject(sender:UIButton){
        
        self.viewModel?.apiFollowRequestAcceptReject(otherUserId: self.viewModel?.arrNotificationList[sender.tag].followID, requestStatus: 2, id: self.viewModel?.arrNotificationList[sender.tag].id)
        
    }
    
    @objc func actionAccept(sender:UIButton){
        
        self.viewModel?.apiFollowRequestAcceptReject(otherUserId: self.viewModel?.arrNotificationList[sender.tag].followID, requestStatus: 1, id: self.viewModel?.arrNotificationList[sender.tag].id)
        
    }
    
}

extension NotificationVC:NotificationListVMObserver{
    func observeUpdateCountSucessfull(comeFrom: String) {
        
        if comeFrom == "No"{
            if self.comeFrom == ""{
                popVC()
            }else{
                self.comeFrom = ""
                isfromAppDelegates = true
                let vc = TabBarController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            
        }
    }
    
    
    func observeAcceptedOrRejectedSucessfull() {
        self.apiCall()
    }
    
    func observeNotificationListSucessfull() {
        notificationTableView.reloadData()
    }
    
}
