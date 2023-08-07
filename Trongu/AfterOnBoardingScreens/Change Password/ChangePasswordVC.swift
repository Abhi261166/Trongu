//
//  ChangePasswordVC.swift
//  Trongu
//
//  Created by dr mac on 24/07/23.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var reenterPswrdText: UITextField!
    @IBOutlet weak var newPswrdTxt: UITextField!
    @IBOutlet weak var oldPswrdTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func btnBack(_ sender: Any) {
        self.popVC()
    }
    

    @IBAction func btnSave(_ sender: Any) {
    }
}
