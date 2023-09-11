//
//  ImageVideoCVCell.swift
//  Trongu
//
//  Created by apple on 05/07/23.
//

import UIKit

class ImageVideoCVCell: UICollectionViewCell {

    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
        
    var originalScale: CGFloat = 1.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delaysContentTouches = false
        
    }

}

extension ImageVideoCVCell:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
               return imgPost
    }
    
}


