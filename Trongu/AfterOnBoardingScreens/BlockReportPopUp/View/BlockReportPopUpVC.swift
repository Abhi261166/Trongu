//
//  BlockReportPopUpVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class BlockReportPopUpVC: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    
    var controller: UIViewController?
    var completion : (() -> Void)? = nil
    var userID:String?
    var postId:String?
    var viewModel:BlockReportVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        setPopUpDismiss()
    }

    func setViewModel(){
        
        self.viewModel = BlockReportVM(observer: self)
    }
    
    func blockApiCall(){
        
        self.viewModel?.apiBlockUser(userId: userID ?? "")
        
    }
    
    func reportApiCall(){
        
        self.viewModel?.apiReportUser(userId: userID ?? "")
    }
    
    func setPopUpDismiss() {
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func actionBlock(_ sender: UIButton) {
        
        blockApiCall()
    }
    
    @IBAction func actionReport(_ sender: UIButton) {
        
        reportApiCall()
    }
    
    @objc func myviewTapped(_ recognizer: UIGestureRecognizer) {
        
        if let completion = completion{
            self.dismiss(animated: true) {}
            completion()
        }
        
    }

}

extension BlockReportPopUpVC:BlockReportVMObserver{
    
    func observeBlockUserSucessfull() {
        if let completion = completion{
            self.dismiss(animated: true) {}
            completion()
        }
    }
    
    func observeReportUserSucessfull() {
        if let completion = completion{
            self.dismiss(animated: true) {}
            completion()
        }
    }
    
}
