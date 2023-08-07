//
//  PostVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.postCollectionView.delegate = self
        self.postCollectionView.dataSource = self
        self.postCollectionView.register(UINib(nibName: "PostCVCell", bundle: nil), forCellWithReuseIdentifier: "PostCVCell")
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension PostVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCVCell", for: indexPath) as! PostCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 290)
    }
}
