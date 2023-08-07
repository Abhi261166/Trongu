//
//  ReportPopUpVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit

class ReportPopUpVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var deleteButton: UIButton!
    
    var controller:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        setPopUpDismiss()
    }
    // MARK: - Functions
    
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
        let vc = EditPostVC()
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
