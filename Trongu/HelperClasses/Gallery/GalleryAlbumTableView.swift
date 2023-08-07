//
//  GalleryAlbumTableView.swift
//  meetwise
//
//  Created by Nitin Kumar on 25/07/21.
//  Copyright © 2021 Nitin Kumar. All rights reserved.
//

import UIKit
import Photos
import PhotosUI


protocol GalleryAlbumTableViewDelegate : UITableViewDelegate {
    func tableView(selection: GalleryAlbumTableView.Section, didSelect ablum: PHCollection?)
}

class GalleryAlbumTableView: UITableView {

    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    var galleryDelegate: GalleryAlbumTableViewDelegate?
    var model: GalleryModel!
    
    
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        static let count = 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCellData()
    }
    
    private func setCellData() {
        
        model = GalleryModel()
        self.dataSource = self
        self.delegate = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: 50))
    }
    
}

extension GalleryAlbumTableView : UITableViewDataSource {
    // MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return model.smartAlbums.count
        case .userCollections: return model.userCollections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = NSLocalizedString("All Photos", comment: "")
            return cell!
        case .smartAlbums:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let collection = model.smartAlbums.object(at: indexPath.row)
            cell?.textLabel?.text = collection.localizedTitle
            return cell!
        case .userCollections:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let collection = model.userCollections.object(at: indexPath.row)
            cell?.textLabel?.text = collection.localizedTitle
            return cell!
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionLocalizedTitles[section]
//    }
    
}

extension GalleryAlbumTableView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected index path is \(indexPath)")
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            galleryDelegate?.tableView(selection: .allPhotos, didSelect: nil)
        case .smartAlbums:
            let data = model.smartAlbums[indexPath.item]
            galleryDelegate?.tableView(selection: .smartAlbums, didSelect: data)
        case .userCollections:
            let data = model.userCollections[indexPath.item]
            galleryDelegate?.tableView(selection: .smartAlbums, didSelect: data)
        }
    }
    
}
