//
//  PhotosDetailsVC.swift
//  Trongu
//
//  Created by apple on 03/10/23.
//

import UIKit

class PhotosDetailsVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var PhotosCollection: UICollectionView!
    
    var arrPhotos:[Image] = []
    var completion : (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotosCollection.delegate = self
        PhotosCollection.dataSource = self
        PhotosCollection.register(UINib(nibName: "PhotosDetailsCVC", bundle: nil), forCellWithReuseIdentifier: "PhotosDetailsCVC")
       

    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        if let completion = completion{
            popVC()
            completion()
        }
        
    }

}

extension PhotosDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPhotos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosDetailsCVC", for: indexPath) as! PhotosDetailsCVC
        
         cell.imgPhoto.setImage(image: self.arrPhotos[indexPath.row].image)
        cell.btnLeft.tag = indexPath.row
        cell.btnRight.tag = indexPath.row
        cell.btnLeft.addTarget(self, action: #selector(actionLeft), for: .touchUpInside)
        cell.btnRight.addTarget(self, action: #selector(actionRight), for: .touchUpInside)
        
        if indexPath.row == 0{
            cell.btnLeft.isHidden = true
        }else{
            cell.btnLeft.isHidden = false
        }
        
        if indexPath.row == (self.arrPhotos.count ) - 1{
            cell.btnRight.isHidden = true
        }else{
            cell.btnRight.isHidden = false
        }
       
        return cell
       
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 430)
  
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        
    }
    
    @objc func actionLeft(sender:UIButton){
        
        let collectionBounds = self.PhotosCollection.bounds
                        let contentOffset = CGFloat(floor(self.PhotosCollection.contentOffset.x - collectionBounds.size.width))
                        self.moveCollectionToFrame(contentOffset: contentOffset)
        PhotosCollection.reloadData()
        
        
    }
    
    @objc func actionRight(sender:UIButton){
        
        let collectionBounds = self.PhotosCollection.bounds
                        let contentOffset = CGFloat(floor(self.PhotosCollection.contentOffset.x + collectionBounds.size.width))
                        self.moveCollectionToFrame(contentOffset: contentOffset)
        PhotosCollection.reloadData()
                        
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
            
            let frame: CGRect = CGRect(x : contentOffset ,y : self.PhotosCollection.contentOffset.y ,width : self.PhotosCollection.frame.width,height : self.PhotosCollection.frame.height)
            self.PhotosCollection.scrollRectToVisible(frame, animated: true)
        }
}
