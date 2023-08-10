//
//  MentionVC.swift
//  Trongu
//
//  Created by Abhi on 06/08/23.
//

import UIKit

class MentionVC: UIViewController {
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: - Valiables -
    var profile = [("LikesImage_1","_rebeka_99","Reveka"),("LikesImage_2","mr.krish_021","Reveka"),("LikesImage_3","dessertsoul_09_","Reveka"),("LikesImage_4","_nishwan_009","Nishwan" ),("LikesImage_5","_uddin509","Reveka"),("LikesImage_6","mahesh_z","Reveka"),("LikesImage_7","_nishwan_009","Nishwan"),("LikesImage_8","_uddin509","Reveka")]
    var viewModel:TagListVM?
    var completion : (( _ name:String, _ id:String ) -> Void)? = nil
    
    //MARK: - Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    //MARK: - Life Cycle Methods -
    func apiCall(){
        self.viewModel?.arrTagList = []
        self.viewModel?.apiTagList()
    }

    func setViewModel(){
        
        self.viewModel = TagListVM(observer: self)
    }
    
    
    func setTableViewDelegates(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MentionTVC", bundle: nil), forCellReuseIdentifier: "MentionTVC")
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
            return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.viewModel?.arrTagList[indexPath.row]
       
        if let completion = self.completion{
            dismiss(animated: true)
            completion(dict?.name ?? "", dict?.id ?? "")
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MentionVC:TagListVMObserver{
    func observePostAddedSucessfull() {
        
    }
    
    func observeGetTagListSucessfull() {
        
        tableView.reloadData()
        
    }
    
}

