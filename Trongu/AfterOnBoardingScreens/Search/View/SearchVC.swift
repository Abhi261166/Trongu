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
        self.viewModel?.pageNo = 0
        self.viewModel?.isLastPage = false
        self.viewModel?.apiSearch(text: "")
    }
    
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Do something with size
            bottomConstraint.constant = keyboardSize.height + 20
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
        
        if searchText.count > 0 {
            isRecentSearch = false
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            self.viewModel?.apiSearch(text: searchText)
        }else{
            isRecentSearch = true
            self.viewModel?.pageNo = 0
            self.viewModel?.isLastPage = false
            self.viewModel?.apiSearch(text: "")
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
    }
}

extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
        if isRecentSearch{
            return viewModel?.arrRecentSearchUserAndPlace.count ?? 0
        }else{
            return viewModel?.arrUserAndPlace.count ?? 0
        }
        
      //  return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVCell", for: indexPath) as! SearchTVCell
     
        let dictSearch = self.viewModel?.arrUserAndPlace[indexPath.row]
        let dictRecentSearch = self.viewModel?.arrRecentSearchUserAndPlace[indexPath.row]
     
        if isRecentSearch{
            
            cell.nameLabel.text = dictRecentSearch?.name
            cell.profileImage.setImage(image: dictRecentSearch?.image,placeholder:UIImage(named: "ic_profilePlaceHolder"))
            
        }else{
            
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

extension SearchVC:SearchVMObserver{
    
    func observeSearchSucessfull() {
        
        searchTableView.reloadData()
        
    }
        
    func setSearchSucessfull() {
        
    }
    
    
}
