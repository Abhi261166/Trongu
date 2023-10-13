//
//  BlockedVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit
class BlockedVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var blockedTableView: UITableView!
    
    var blockedProfile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    
    var viewModel:BlockListVM?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.blockedTableView.delegate = self
        self.blockedTableView.dataSource = self
        self.blockedTableView.register(UINib(nibName: "LikesTVCell", bundle: nil), forCellReuseIdentifier: "LikesTVCell")
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }

    func setViewModel(){
        self.viewModel = BlockListVM(observer: self)
    }
    
    func apiCall(){
        self.viewModel?.userArray = []
        self.viewModel?.pageNo = 0
        self.viewModel?.apiBlockUserList(text: "")
        
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
        
        if searchText.trim.count > 0 {
            
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            self.viewModel?.apiBlockUserList(text: searchText)
        }
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
extension BlockedVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel?.userArray.count == 0{
            self.blockedTableView.setBackgroundView(message: "No blocked user yet")
            return 0
        }else{
            self.blockedTableView.setBackgroundView(message: "")
            return self.viewModel?.userArray.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTVCell", for: indexPath) as! LikesTVCell
        
        let dict = self.viewModel?.userArray[indexPath.row]
        
        cell.profileImage.setImage(image: dict?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        cell.userNameLabel.text = dict?.user_name
        cell.nameLabel.text = dict?.name
        cell.followButton.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 0.7)
        cell.followButton.setTitle("Unblock", for: .normal)
        cell.followButton.setTitleColor(.black, for: .normal)
        cell.followButton.tag = indexPath.row
        cell.followButton.addTarget(self, action: #selector(actionUnblock), for: .touchUpInside)
        
        return cell
    }
    
    @objc func actionUnblock(sender:UIButton){
        self.viewModel?.apiUnblockUser(userId: self.viewModel?.userArray[sender.tag].id ?? "")
    }
    
}

extension BlockedVC: BlockListVMObserver{
    
    func observeBlockListFetchedSuccessfull() {
        
        blockedTableView.reloadData()
    }
    
    func observeUnblockSucessfull() {
        apiCall()
    }
    
}
