//
//  MentionVC.swift
//  Trongu
//
//  Created by Abhi on 06/08/23.
//

import UIKit
import IQKeyboardManager

class MentionVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnTag: UIButton!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    
    //MARK: - Valiables -
    var profile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    var viewModel:TagListVM?
    var completion : (( _ tagedPeople:[Userdetail] ) -> Void)? = nil
    var timer: Timer?
    var keyboard: KeyboardVM?
    var selectedPeople:[Userdetail] = []
    
    
    //MARK: - Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        setViewModel()
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        apiCall()
        keyboard = KeyboardVM()
        keyboard?.setKeyboardNotification(self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
        keyboard?.removeKeyboardNotification()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateCrossButtonVisibility()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.searchTimerAction(_:)), userInfo: textField.text, repeats: false)
    }
    func updateCrossButtonVisibility() {
        btnCross.isHidden = false
        btnCross.isHidden = txtSearch.text?.isEmpty ?? true
    }
    
    @objc func searchTimerAction(_ timer:Timer) {
        guard let searchText = timer.userInfo as? String else{return}
        print(searchText)
        
        self.apiSearchCall(text: searchText.trim)
        
       
    }
    //MARK: - Life Cycle Methods -
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

    func setViewModel(){
        
        self.viewModel = TagListVM(observer: self)
    }
    
    
    func setTableViewDelegates(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MentionTVC", bundle: nil), forCellReuseIdentifier: "MentionTVC")
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        
        txtSearch.text = ""
        btnCross.isHidden = true
        apiCall()
        
    }
    
    @IBAction func actionTag(_ sender: UIButton) {
        
        if selectedPeople.count > 0{
            
            if let completion = completion{
                dismiss(animated: true)
                completion(selectedPeople)
                
            }
            
        }else{
            
            Singleton.shared.showErrorMessage(error: "Please select atleast one person for tag.", isError: .error)
        }
        
    }
    
    
}
extension MentionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel?.arrTagList.count == 0 {
            self.tableView.setBackgroundView(message: "Tag list not found")
            
        }else{
            self.tableView.setBackgroundView(message: "")
        }
        
        return self.viewModel?.arrTagList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionTVC", for: indexPath) as! MentionTVC
        
        let dict = self.viewModel?.arrTagList[indexPath.row]
        cell.profileImage.setImage(image: dict?.image,placeholder: UIImage(named: "ic_profilePlaceHolder"))
        cell.userNameLabel.text = dict?.userName
        cell.nameLabel.text = dict?.name
        
       let dataid = self.selectedPeople.map({$0.id})
        
        if dataid.contains(dict?.id ?? "") {
            cell.btnSelect.isSelected = true
        }else{
            cell.btnSelect.isSelected = false
        }
        
        cell.btnSelect.isUserInteractionEnabled = false
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(target: self, action: #selector(actionSelect))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let dataid = self.selectedPeople.map({$0.id})
        
        if dataid.contains(self.viewModel?.arrTagList[indexPath.row].id ?? "") {

            let valueToDelete = self.viewModel?.arrTagList[indexPath.row].id ?? ""

            // Use a for loop to iterate through the dictionary
            for (index, value) in selectedPeople.enumerated() {
                
                if selectedPeople[index].id == valueToDelete{
                    self.selectedPeople.remove(at: index)
                    print("selected count --- ",selectedPeople.count)
                    tableView.reloadData()
                    break
                }
            }
            
            
        }else{
            
            if selectedPeople.count < 5 {
                self.selectedPeople.append((self.viewModel?.arrTagList[indexPath.row])!)
                print("selected count --- ",selectedPeople.count)
                tableView.reloadData()
            }else{
                
                Singleton.shared.showErrorMessage(error: "Tag limit exceeded. You can only tag up to 5 people.", isError: .error)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func actionSelect(sender:UIButton){
        
       
        
//        let dataid = self.selectedPeople.map({$0.id})
//
//        if dataid.contains(self.viewModel?.arrTagList[sender.tag].id ?? "") {
//
//            let valueToDelete = self.viewModel?.arrTagList[sender.tag].id ?? ""
//
//            // Use a for loop to iterate through the dictionary
//            for (index, value) in selectedPeople.enumerated() {
//
//                if selectedPeople[index].id == valueToDelete{
//                    self.selectedPeople.remove(at: index)
//                    print("selected count --- ",selectedPeople.count)
//                    tableView.reloadData()
//                    break
//                }
//            }
//
//
//        }else{
//            self.selectedPeople.append((self.viewModel?.arrTagList[sender.tag])!)
//            print("selected count --- ",selectedPeople.count)
//            tableView.reloadData()
//        }
        
        
    }
    
}

extension MentionVC:TagListVMObserver{
    func observerSendMessages(json: JSON, roomId: String?, sender: UIButton?) {
        
    }
    
    
   
    
    
    func observeGetCategoriesListSucessfull() {
        
    }
    
    func observePostAddedSucessfull() {
        
    }
    
    func observeGetTagListSucessfull() {
        
        tableView.reloadData()
        
    }
    
}

extension MentionVC: KeyboardVMObserver {
    
    func keyboard(didChange height: CGFloat, duration: Double, animation: UIView.AnimationOptions) {
        if txtSearch.isFirstResponder {
            if bottomCons.constant == height {
                return
            }
        } else {
            if bottomCons.constant == 0 {
                return
            }
        }
        print("height is \(height)")
        self.bottomCons.constant = height
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animation, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { finished in
            //self.scrollToBottom(isScrolled: false)
        })
    }
    
}
