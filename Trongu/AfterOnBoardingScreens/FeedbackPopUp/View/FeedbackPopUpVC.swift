//
//  FeedbackPopUpVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit

class FeedbackPopUpVC: UIViewController, UIGestureRecognizerDelegate  {

    var completion : (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            
            if let completion = completion{
                self.dismiss(animated: true) {}
                completion()
                
            }
            
        })
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
