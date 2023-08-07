//
//  UICollectionView+Custom.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 04/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import Foundation
import UIKit

typealias RefreshCallback = ((_ data: UIRefreshControl) -> ())

class RefreshControl: UIRefreshControl {
    var callback: RefreshCallback?
}

extension UICollectionView {
    func registerCell(identifier:String) {
        self.register(UINib(nibName:identifier, bundle:nil), forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeader(nibName:String) {
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    func registerFooter(nibName:String) {
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName)
    }
    
    func setBackgroundView(message:String) {
        // let view = UIView(frame: self.frame)
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.placeholderColor
        label.textAlignment = .center
        label.font = UIFont.setCustom(.Cinzel_Bold, 24)
        label.center = CGPoint(x: self.center.x, y: self.center.y - 150)
        self.backgroundView = label
    }
    
//    func setBackgroundMessage(message:String) {
//        // let view = UIView(frame: self.frame)
//        let label = UILabel()
//        label.text = message
//        label.textColor = UIColor.black
//        label.textAlignment = .center
//        label.font = UIFont.setCustom(.OS_Bold, 16)
//        label.center = CGPoint(x: self.center.x, y: self.center.y - 150)
//        self.backgroundView = label
//    }
    
    
    
    func addRefreshControl(refresh: @escaping(RefreshCallback)) {
        let refreshControl = RefreshControl()
        refreshControl.callback = refresh
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refresh: RefreshControl) {
        refresh.callback?(refresh)
    }
    
}

extension UICollectionViewCell {
    // Search up the view hierarchy of the table view cell to find the containing table view
    var collectionView: UICollectionView? {
        get {
            var table: UIView? = superview
            while !(table is UICollectionView) && table != nil {
                table = table?.superview
            }
            return table as? UICollectionView
        }
    }
    
    var indexPath:IndexPath? {
        return self.collectionView?.indexPath(for: self)
    }
    
}

