//
//  FeedbackVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit
import GrowingTextView

class FeedbackVC: UIViewController {

    
    @IBOutlet weak var btnSendFeedback: UIButton!
    @IBOutlet weak var txtFldFeedBackType: UITextField!
    @IBOutlet weak var txtVwFeedback: GrowingTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendFeedbackAction(_ sender: UIButton) {
        let vc = FeedbackPopUpVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
}
