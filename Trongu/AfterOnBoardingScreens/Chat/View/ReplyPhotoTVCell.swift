//
//  ReplyPhotoTVCell.swift
//  Trongu
//
//  Created by apple on 01/07/23.
//

import UIKit

class ReplyPhotoTVCell: UITableViewCell {

    @IBOutlet weak var replyPhotoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.replyPhotoCollectionView.delegate = self
        self.replyPhotoCollectionView.dataSource = self
        self.replyPhotoCollectionView.register(UINib(nibName: "ReplyPhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "ReplyPhotoCVCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
extension ReplyPhotoTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReplyPhotoCVCell", for: indexPath) as! ReplyPhotoCVCell
        if indexPath.row == 3{
            cell.photoCountLabel.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: 105)
    }
}
