//
//  NotificationVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    var notification = [("NotificationImage_1","James Perry, are requested to follow you","4h"),("NotificationImage_2","Kevin Lowe, Started following you","5h"),("NotificationImage_3","Kevin Lowe, Started following you","12h"),("NotificationImage_4","Jasmine Blake, liked your post","13h")]
    
    var boldname = ["James Perry,","Kevin Lowe,","Kevin Lowe,","Jasmine Blake,"]
    
    var following = [" are requested to follow you"," Started following you"," Started following you"," liked your post"]
    var viewModel:NotificationListVM?
    
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
    }

    func setViewModel(){
        
        self.viewModel = NotificationListVM(observer: self)
        
    }
    
    func apiCall(){
        
        self.viewModel?.apiNotificationList()
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        cell.timeLabel.text = "\(notification[indexPath.row].2)"
        cell.nameLabel.setAttributed(str1: "\(dict?.userName ?? "")", font1: UIFont.setCustom(.Poppins_Medium, 16), color1: .black, str2: "\(dict?.notification ?? "")", font2: UIFont.setCustom(.Poppins_Regular, 16), color2: .gray)
        if indexPath.row == 0{
            cell.buttonStackView.isHidden = false
            cell.stackViewHeightConst.constant = 30
        }
        else{
            cell.buttonStackView.isHidden = true
            cell.stackViewHeightConst.constant = 0
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension NotificationVC:NotificationListVMObserver{
    
    
    func observeNotificationListSucessfull() {
        notificationTableView.reloadData()
    }
    
    
}
