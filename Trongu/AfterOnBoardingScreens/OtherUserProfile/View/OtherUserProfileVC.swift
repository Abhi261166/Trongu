//
//  OtherUserProfileVC.swift
//  Trongu
//
//  Created by apple on 29/06/23.
//

import UIKit

class OtherUserProfileVC: UIViewController {
    
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var OtherUserCollectionView: UICollectionView!
    var image = ["OtherUserImage_1","OtherUserImage_3","OtherUserImage_3","OtherUserImage_4","OtherUserImage_5","OtherUserImage_6","OtherUserImage_7","OtherUserImage_8","OtherUserImage_9","OtherUserImage_7","OtherUserImage_8","OtherUserImage_9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.OtherUserCollectionView.delegate = self
        self.OtherUserCollectionView.dataSource = self
        self.OtherUserCollectionView.register(UINib(nibName: "OtherUserProfileCVCell", bundle: nil), forCellWithReuseIdentifier: "OtherUserProfileCVCell")
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: UIButton) {
        let vc = BlockReportPopUpVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        self.sideMenuButton.isHidden = true
    }
    
    @IBAction func followersAction(_ sender: UIButton) {
        let vc = FollowersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followingAction(_ sender: UIButton) {
        let vc = FollowersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        let vc = ChatVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension OtherUserProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCVCell", for: indexPath) as! OtherUserProfileCVCell
        cell.postImage.image = UIImage(named: image[indexPath.row])
        cell.locationView.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3), height:120)
    }
    
}
