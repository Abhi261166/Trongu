//
//  LoginVc.swift
//  Trongu
//
//  Created by apple on 27/06/23.
//

import UIKit
class LoginVc: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var hidePasswordBtn: UIButton!
    @IBOutlet weak var rememberMeBtn: UIButton!
    
    @IBOutlet weak var btnRememberMe: UIButton!
    var viewModel: LoginVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        passwordTF.isSecureTextEntry = true
        emailTF.delegate = self
        passwordTF.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setValue()
    }
    
    func setViewModel() {
        self.viewModel = LoginVM(observer: self)
        
    }
    
    func setValue(){
        self.emailTF.text = UserDefaults.standard.string(forKey: "email")
        self.passwordTF.text = UserDefaults.standard.string(forKey: "pass")
        
        if UserDefaults.standard.string(forKey: "email") == nil{
            btnRememberMe.isSelected = false
        }else{
            btnRememberMe.isSelected = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
       if textField == emailTF || textField == passwordTF  {
            if string == " " {
                return false
            }else{}
            
        }else {
            
        }
        return true
    }
    
    func validation() {
        if (emailTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEmail, view: self)
        }else if emailTF.text?.isValidEmail == false {
            Trongu.showAlert(title: Constants.AppName, message: Constants.validEmail, view: self)
        }else if(passwordTF.text?.isEmpty)!{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPassword, view: self)
        }else if passwordTF?.isValidPassword() == false {
            Trongu.showAlert(title: Constants.AppName, message: Constants.minimumRangeSet, view: self)
        }else{
            viewModel?.apiLogin(email: self.emailTF.text ?? "", password: self.passwordTF.text ?? "")
            UserDefaults.setValue(value: self.passwordTF.text ?? "", for: "password")  
//            let vc = TabBarController()
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func hidePasswordAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTF.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func rememberMeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let vc = ForgotPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logInAction(_ sender: UIButton) {
        validation()

    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
extension LoginVc : LoginVMObserver{
    func observeLoginSucessfull(){
        if btnRememberMe.isSelected == true{
            UserDefaults.setValue(value: self.emailTF.text ?? "", for: "email")
            UserDefaults.setValue(value: self.passwordTF.text ?? "", for: "pass")
        }else{
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "pass")
        }
        let vc = TabBarController()
        self.navigationController?.pushViewController(vc, animated: true)
                
    }
}
