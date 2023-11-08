//
//  SearchVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit

class SearchVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentLable: UILabel!
    
    var timer: Timer?
    var viewModel:SearchVM?
    var isRecentSearch = false
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.register(UINib(nibName: "SearchTVCell", bundle: nil), forCellReuseIdentifier: "SearchTVCell")
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchApiCall()
    }
    
    func setViewModel() {
        
        self.viewModel = SearchVM(observer: self)
    }
    
    func searchApiCall(){
        isRecentSearch = true
        self.searchTF.text = ""
        self.viewModel?.pageNo = 0
        self.viewModel?.isLastPage = false
        self.viewModel?.arrUserAndPlace = []
        self.viewModel?.arrRecentSearchUserAndPlace = []
        self.viewModel?.apiSearch(text: "")
        self.recentLable.isHidden = false
        self.recentLable.text = "Recent Search"
        self.crossButton.isHidden = true
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Do something with size
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
        
        if searchText.count > 0 {
            isRecentSearch = false
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            self.viewModel?.arrUserAndPlace = []
            self.viewModel?.apiSearch(text: searchText)
            self.recentLable.isHidden = true
            self.recentLable.text = ""
        }else{
            isRecentSearch = true
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            self.recentLable.isHidden = false
            self.viewModel?.arrUserAndPlace = []
            self.viewModel?.apiSearch(text: "")
            self.recentLable.text = "Recent Search"
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
        searchApiCall()
    }
}

extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        if isRecentSearch{
            if self.viewModel?.arrRecentSearchUserAndPlace.count == 0{
                self.searchTableView.setBackgroundView(message: "No recent search yet.")
                return 0
            }else{
                self.searchTableView.setBackgroundView(message: "")
                return viewModel?.arrRecentSearchUserAndPlace.count ?? 0
            }
        }else{
            if self.viewModel?.arrUserAndPlace.count == 0{
                self.searchTableView.setBackgroundView(message: "No results found.")
                return 0
            }else{
                self.searchTableView.setBackgroundView(message: "")
                return viewModel?.arrUserAndPlace.count ?? 0
            }
        }
        
        //  return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCell", for: indexPath) as! SearchTVCell
        
        if isRecentSearch{
            
            if self.viewModel?.arrRecentSearchUserAndPlace.count ?? 0 > 0{
                
                let dictRecentSearch = self.viewModel?.arrRecentSearchUserAndPlace[indexPath.row]
                cell.nameLabel.text = dictRecentSearch?.name
                cell.btnDeleteRecent.isHidden = false
                cell.btnDeleteRecent.tag = indexPath.row
                cell.btnDeleteRecent.addTarget(self, action: #selector(actionDeleteFromRecent), for: .touchUpInside)
                
                cell.profileImage.setImage(image: dictRecentSearch?.image,placeholder:UIImage(named: "ic_profilePlaceHolder"))
            }
            
        }else{
            let dictSearch = self.viewModel?.arrUserAndPlace[indexPath.row]
            cell.btnDeleteRecent.isHidden = true
            if dictSearch?.actionType == "1"{
                cell.nameLabel.text = dictSearch?.name
                cell.profileImage.setImage(image: dictSearch?.image,placeholder:UIImage(named: "ic_profilePlaceHolder"))
            }else{
                cell.nameLabel.text = dictSearch?.place
                cell.profileImage.setImage(image: dictSearch?.image,placeholder:UIImage(named: "ic_profilePlaceHolder"))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isRecentSearch{
            
            if self.viewModel?.arrRecentSearchUserAndPlace[indexPath.row].actionType == "1"{
                let dictRecentSearch = self.viewModel?.arrRecentSearchUserAndPlace[indexPath.row]
                let vc = OtherUserProfileVC()
                vc.userId = dictRecentSearch?.id
                self.pushViewController(vc, true)
                print("in recent search")
            }else{
                Singleton.shared.showErrorMessage(error: "Not implemented yet..", isError: .message)
            }
            
        }else{
            if self.viewModel?.arrUserAndPlace[indexPath.row].actionType == "1"{
                let dictSearch = self.viewModel?.arrUserAndPlace[indexPath.row]
                self.viewModel?.apiAddRecentHistory(actionId: dictSearch?.actionID ?? "", actionType: dictSearch?.actionType ?? "")
                let vc = OtherUserProfileVC()
                vc.userId = dictSearch?.actionID
                self.pushViewController(vc, true)
            }else{
                //Singleton.shared.showErrorMessage(error: "Not implemented yet..", isError: .message)
                let dict = self.viewModel?.arrUserAndPlace[indexPath.row]
                let vc = DetailVC()
                vc.completion = {
                    
                }
                vc.postId = dict?.postID
                vc.hidesBottomBarWhenPushed = true
                self.pushViewController(vc, true)
                
            }
        }
        
    }
    
    @objc func actionDeleteFromRecent(sender:UIButton){
        
        let dictRecentSearch = self.viewModel?.arrRecentSearchUserAndPlace[sender.tag]
        self.viewModel?.apiRemoveRecentHistory(actionId: dictRecentSearch?.id ?? "", actionType: dictRecentSearch?.actionType ?? "")
        
        // Singleton.shared.showErrorMessage(error: "Not implemented yet.", isError: .message)
    }
    
}

extension SearchVC:SearchVMObserver{
    
    func observeDeleteFromRecentSucessfull() {
        searchApiCall()
    }
    
    func observeSearchSucessfull() {
        
        searchTableView.reloadData()
        
    }
    
}
