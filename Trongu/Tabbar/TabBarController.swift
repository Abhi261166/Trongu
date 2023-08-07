
//  TabBarController.swift
//  Trongu
//
//  Created by apple on 07/04/23


import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var dotView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        tabBar.backgroundColor = .white
//        tabBar.unselectedItemTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        tabBar.selectedImageTintColor =  #colorLiteral(red: 0.9294117647, green: 0.5725490196, blue: 0.2352941176, alpha: 1)
        //        tabBar.addBorder(.top, color: #colorLiteral(red: 0.9294117689, green: 0.9294117093, blue: 0.9294117689, alpha: 1), thickness: 1.0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        tabBar.layer.shadowOpacity = 0.3

        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named:  "HomeUnSelectImage")?.renderOriginalMode, selectedImage: UIImage(named: "HomeSelectImage")?.renderOriginalMode)
        homeVC.tabBarItem.tag = 0

        let bucketListVC = BucketListVC()
        bucketListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named:  "BucketListUnSelectImage")?.renderOriginalMode, selectedImage: UIImage(named: "BucketListSelectImage")?.renderOriginalMode)
        bucketListVC.tabBarItem.tag = 1

        let createPostVC = CreatePostVC()
        createPostVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "CreatePostUnSelectImage")?.renderOriginalMode, selectedImage: UIImage(named: "CreatePostSelectImage")?.renderOriginalMode)
        createPostVC.tabBarItem.tag = 2

        let messageVC = MessageVC()
        messageVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "MessageUnSelectImage")?.renderOriginalMode, selectedImage: UIImage(named: "MessageSelectImage")?.renderOriginalMode)
        messageVC.tabBarItem.tag = 3

        let userProfileVC = UserProfileVC()
        userProfileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "UserProfileUnSelectImage")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "UserProfileSelectImage")?.withRenderingMode(.alwaysOriginal))
        userProfileVC.tabBarItem.tag = 4


        let viewControllers = [homeVC, bucketListVC, createPostVC,messageVC,userProfileVC]
        viewControllers.forEach { vc in
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)

        }
        self.viewControllers = viewControllers.map { vc in
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            return nav
        }

    }
}
//    override func viewDidLayoutSubviews() {
//           super.viewDidLayoutSubviews()
//           tabBar.frame.size.height = 70
//           tabBar.frame.origin.y = view.frame.size.height - 70
//       }





extension UITabBar {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
}

