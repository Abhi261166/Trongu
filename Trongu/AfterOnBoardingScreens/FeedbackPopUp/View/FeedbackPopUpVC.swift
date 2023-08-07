//
//  FeedbackPopUpVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit

class FeedbackPopUpVC: UIViewController, UIGestureRecognizerDelegate  {

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
        self.dismiss(animated: true) {}
    }



}
