//
//  BlockReportPopUpVC.swift
//  Trongu
//
//  Created by apple on 30/06/23.
//

import UIKit

class BlockReportPopUpVC: UIViewController,UIGestureRecognizerDelegate {

    
    var controller: UIViewController?
    var completion : (() -> Void)? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPopUpDismiss()
    }

    func setPopUpDismiss() {
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func myviewTapped(_ recognizer: UIGestureRecognizer) {
        
        if let completion = completion{
            self.dismiss(animated: true) {}
            completion()
        }
        
        
    }

}
