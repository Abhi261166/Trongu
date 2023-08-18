//
//  ReportPopUpVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class ReportPopUpVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var deleteButton: UIButton!
    
    var objMyPost:Post?
    var controller:UIViewController?
    var viewModel:DeleteVM?
    var completion : (() -> Void)? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPopUpDismiss()
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = DeleteVM(observer: self)
    }
    
    
    // MARK: - Functions -
    
    func setPopUpDismiss() {
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func myviewTapped(_ recognizer: UIGestureRecognizer) {
        self.dismiss(animated: true) {}
    }

    @IBAction func editPostAction(_ sender: UIButton) {
        dismiss(animated: true)
        let vc = CreatePostVC()
        vc.hidesBottomBarWhenPushed = true
        vc.comeFrom = "Edit"
        vc.myPost.append(objMyPost!)
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        self.viewModel?.apiDeletePost(postId: objMyPost?.id ?? "")
        
    }
    
}

extension ReportPopUpVC:DeleteVMObserver{
    
    func observeDeletePostSucessfull() {
        
        if let completion = completion{
            self.dismiss(animated: true)
            completion()
        }
        
    }
    
}
