//
//  ReceivePhotoTVCell.swift
//  Trongu
//
//  Created by apple on 01/07/23.
//

import UIKit

class ReceivePhotoTVCell: UITableViewCell {

    @IBOutlet weak var receivePhotoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.receivePhotoCollectionView.delegate = self
        self.receivePhotoCollectionView.dataSource = self
        self.receivePhotoCollectionView.register(UINib(nibName: "ReceivePhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "ReceivePhotoCVCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
extension ReceivePhotoTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceivePhotoCVCell", for: indexPath) as! ReceivePhotoCVCell
        if indexPath.row == 3{
            cell.photoCountLabel.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: 105)
    }
}
