//
//  BucketListVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit

class BucketListVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bucketListTableView: UITableView!
    
    var bucketList = [("BucketListImage_1","Christian","Lorem Ipsum is simply dummy text of the printing and typesetting industry."),("BucketListImage_2","Apollonia","Lorem Ipsum is simply dummy text of the printing and typesetting industry. ")]
    
    var comeFrom:String?
    var viewModel:BucketListVM?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bucketListTableView.delegate = self
        self.bucketListTableView.dataSource = self
        self.bucketListTableView.register(UINib(nibName: "BucketListTVCell", bundle: nil), forCellReuseIdentifier: "BucketListTVCell")
        setViewModel()
        let deviceTimeZone = TimeZone.current

        // You can also get the time zone abbreviation if needed
        let timeZoneAbbreviation = deviceTimeZone.abbreviation() ?? "Unknown"

        print("Device Time Zone: \(deviceTimeZone.identifier)")
        print("Time Zone Abbreviation: \(timeZoneAbbreviation)")
       
    }
    
    func setViewModel(){
        
        self.viewModel = BucketListVM(observer: self)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.comeFrom == "NotFromTabbar"{
            backButton.isHidden = false
            
        }
        apiCall()
    }
    
    
    func apiCall(){
        self.viewModel?.pageNo = 0
        self.viewModel?.arrPostList = []
        self.viewModel?.apiBucketList()
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension BucketListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel?.arrPostList.count ?? 0 == 0 {
            self.bucketListTableView.setBackgroundView(message: "No bucket listing")
            return 0
        }else{
            self.bucketListTableView.setBackgroundView(message: "")
            return self.viewModel?.arrPostList.count ?? 0
        }
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListTVCell", for: indexPath) as! BucketListTVCell
       
        let dict = self.viewModel?.arrPostList[indexPath.row]
        
        if dict?.postImagesVideo.first?.type == "0"{
            cell.profileImage.setImage(image: dict?.postImagesVideo.first?.image)
        }else{
            cell.profileImage.setImage(image: dict?.postImagesVideo.first?.thumbNailImage)
        }
        
        cell.nameLabel.text = dict?.userDetail.name
        cell.discriptionLabel.text = dict?.description
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension BucketListVC:BucketListVMObserver{
    
    func observeGetBucketListDataSucessfull() {
    
        self.bucketListTableView.reloadData()
    }
   
}
