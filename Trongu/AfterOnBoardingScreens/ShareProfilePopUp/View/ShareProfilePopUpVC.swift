//
//  ShareProfilePopUpVC.swift
//  Trongu
//
//  Created by apple on 03/07/23.
//

import UIKit

class ShareProfilePopUpVC: PannableViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var shareTableView: UITableView!
    var profile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    
    var timer: Timer?
    var viewModel:TagListVM?
    var postid:String?
    var otherUserName:String?
    var otherUserId:String?
    var otherUserProfileImage:String?
    var controller:UIViewController?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.shareTableView.delegate = self
        self.shareTableView.dataSource = self
        self.shareTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       // setPopUpDismiss()
        setViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    func setViewModel(){
        
        self.viewModel = TagListVM(observer: self)
        
    }
    
    func apiCall(){
        self.viewModel?.arrTagList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiTagList(text: "")
    }
    
    func apiSearchCall(text:String?){
        self.viewModel?.arrTagList = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiTagList(text: text)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    
    func updateCrossButtonVisibility() {
        crossButton.isHidden = false
        crossButton.isHidden = searchTF.text?.isEmpty ?? true
    }
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
        
        self.apiSearchCall(text: searchText.trim)
        
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
       
        searchTF.text = ""
        crossButton.isHidden = true
        apiCall()
    }

}
extension ShareProfilePopUpVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel?.arrTagList.count == 0 {
            self.shareTableView.setBackgroundView(message: "No data found")
            
        }else{
            self.shareTableView.setBackgroundView(message: "")
        }
        
        return self.viewModel?.arrTagList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
        
            let dict = self.viewModel?.arrTagList[indexPath.row]
        
            cell.profileImage.setImage(image: dict?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
            cell.userNameLabel.text = dict?.userName
            cell.nameLabel.text = dict?.name
            cell.followButton.setTitle("Send", for: .normal)
            cell.followWidthCons.constant = 80
            cell.followButton.tag = indexPath.row
            cell.followButton.addTarget(target: self, action: #selector(actionSend))
            return cell
            
    }
    
    
    @objc func actionSend(sender:UIButton){
        
        let dict = self.viewModel?.arrTagList[sender.tag]
        self.otherUserId = dict?.id
        self.otherUserProfileImage = dict?.image
        self.otherUserName = dict?.userName
        ChatVM.apiCreateRoom(otherUserId: self.otherUserId ?? "", observer: self)
  
    }
    
}

extension ShareProfilePopUpVC: TagListVMObserver{
    
    
    func observeGetTagListSucessfull() {
        
        shareTableView.reloadData()
    }
    
}

extension ShareProfilePopUpVC: CreateRoomObserver{
    func observeCreateRoom(model: ChatUserData) {
        let vc = ChatVC(roomId: model.roomID, otherUserName: self.otherUserName ?? "", otherUserId: model.userID, otherUserProfileImage: self.otherUserProfileImage ?? "" )
        vc.comeFrom = "SharePost"
        vc.postId = self.postid
        self.dismiss(animated: false)
        controller?.pushViewController(vc, true)
    }
    
}
