//
//  ForgotPasswordVC.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    var viewModel: ForgotPasswordVM?
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewModel()
    }
    func setViewModel() {
        self.viewModel = ForgotPasswordVM(observer: self)
    }
    func validation(){
        if (emailTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEmail, view: self)
        }else if emailTF.text?.isValidEmail == false {
            Trongu.showAlert(title: Constants.AppName, message: Constants.validEmail, view: self)
        }else{
            viewModel?.apiForgotPassword(email: self.emailTF.text ?? "")
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        validation()
    }
    
}

extension ForgotPasswordVC : ForgotPasswordVMObserver{
    func observeForgotPasswordSucessfull() {
        self.navigationController?.popViewController(animated: true)
    }
}
