//
//  LikesVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit
class LikesVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var likesTableView: UITableView!
    
    var timer: Timer?
    var postId:String?
    var viewModel:LikesVM?
    var likes = [("LikesImage_1","_rebeka_99","Reveka","Followed by _akshara_1..."),("LikesImage_2","mr.krish_021","Reveka","Followed by _akshara_1..."),("LikesImage_3","dessertsoul_09_","Reveka","Followed by _akshara_1..."),("LikesImage_4","_nishwan_009","Nishwan","Followed by _rebeka_1..."),("LikesImage_5","_uddin509","Reveka","Followed by _akshara_1..."),("LikesImage_6","mahesh_z","Reveka","Followed by _akshara_1..."),("LikesImage_7","_nishwan_009","Nishwan","Followed by _rebeka_1..."),("LikesImage_8","_uddin509","Reveka","Followed by _akshara_1...")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.likesTableView.delegate = self
        self.likesTableView.dataSource = self
        self.likesTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        apiCall()
    }

    func setViewModel(){
        self.viewModel = LikesVM(observer: self)
        
    }
    
    func apiCall(){
        self.viewModel?.pageNo = 0
        self.viewModel?.arrUsers = []
      //  self.viewModel?.apiLikesList(postId: self.postId ?? "")
        self.viewModel?.apiSearch(postId: self.postId ?? "" , text: "")
        
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
        self.viewModel?.apiSearch(postId: self.postId ?? "", text: searchText)
        
    }
    
    func updateCrossButtonVisibility() {
        crossButton.isHidden = false
        crossButton.isHidden = searchTF.text?.isEmpty ?? true
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        searchTF.text = ""
        crossButton.isHidden = true
        apiCall()
    }
    
}

extension LikesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.arrUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
        let dict = self.viewModel?.arrUsers[indexPath.row]
        cell.profileImage.setImage(image: dict?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        cell.userNameLabel.text = dict?.userName
        cell.nameLabel.text = dict?.name
        cell.followButton.addTarget(self, action: #selector(actionFollow), for: .touchUpInside)
        
        if UserDefaultsCustom.getUserData()?.id == dict?.id{
            
            cell.followButton.isHidden = true
        }else{
            cell.followButton.isHidden = false
        }
        
        return cell
        
    }
    
    @objc func actionFollow(){
        
        Singleton.shared.showErrorMessage(error: "Not Implemented Yet", isError: .message)
    }
    
}

extension LikesVC:LikesVMObserver{
    
    func observeSearchLikesListSucessfull() {
        self.likesTableView.reloadData()
        
    }
    
    
    func observeLikesListSucessfull() {
        
        self.likesTableView.reloadData()
        
    }
    
}
