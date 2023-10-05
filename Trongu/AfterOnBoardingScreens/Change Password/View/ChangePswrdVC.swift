//
//  ChangePswrdVC.swift
//  Trongu
//
//  Created by dr mac on 24/07/23.
//

import UIKit

class ChangePswrdVC: UIViewController {
   
    

    @IBOutlet weak var reEnterPswrdText: UITextField!
    @IBOutlet weak var newPswrdText: UITextField!
    @IBOutlet weak var oldPswrdText: UITextField!
    
    var viewModel: ChangePasswordVM?
    var errorTitle = "Change Password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setViewModel()
       
    }

    func setViewModel() {
        self.viewModel = ChangePasswordVM(observer: self)
    }
    
    @IBAction func actionShowHidePass(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            sender.isSelected.toggle()
            oldPswrdText.isSecureTextEntry = !sender.isSelected
        case 1:
            sender.isSelected.toggle()
            newPswrdText.isSecureTextEntry = !sender.isSelected
        case 2:
            sender.isSelected.toggle()
            reEnterPswrdText.isSecureTextEntry = !sender.isSelected
        default:
            break
        }
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: oldPswrdText.text) == true {
            showAlertMessage(title: errorTitle , message: "Please enter current password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: newPswrdText.text) == true {
            showAlertMessage(title: errorTitle  , message: "Please enter new password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        if (newPswrdText!.text!.count ) < 8 || (newPswrdText!.text!.count) > 15 {
            showAlertMessage(title: errorTitle  ,  message: "Please enter minimum 8 characters." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: reEnterPswrdText.text) == true {
            showAlertMessage(title: errorTitle  , message: "Please confirm new password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        if (newPswrdText.text != reEnterPswrdText.text) {
            showAlertMessage(title: errorTitle  , message: "Oops! It looks like the new password and re-enter new password fields don't match." , okButton: "Ok", controller: self) {
            }
            return false
        }
        return true
    }
    @IBAction func btnSave(_ sender: Any) {
        if validate() == false {
            return
        }
        else{
//            self.popVC()
            viewModel?.apiChangePassword(oldPswrd: self.oldPswrdText.text ?? "", newPswrd: self.newPswrdText.text ?? "")
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.popVC()
    }
    

}
extension ChangePswrdVC: ChangePasswordVMObserver{
    func observeGetChangePasswordSucessfull() {
        UIView.animate(withDuration: 0.3) {
            self.popViewController(true)
            
        }
    }
}

enum RegularExpressions: String {
    case name = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    case url = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    case age = "^(?:1[0][0]|100|1[8-9]|[2-9][0-9])$"
    case password8AS = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    case password82US2N3L = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
}

class ValidationManager: NSObject {
    
    let kNameMinLimit = 2
    let kPasswordMinLimit = 8
    let kPasswordMaxLimit = 20
    
    //------------------------------------------------------
           
    //MARK: Shared
              
    static let shared = ValidationManager()
   
    //------------------------------------------------------
    
    //MARK: Private
    
    private func isValid(input: String, matchesWith regex: String) -> Bool {
        let matches = input.range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    //------------------------------------------------------
    
    //MARK: Public
    
    func isEmpty(text : String?) -> Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    
    func isValid(text: String, for regex: RegularExpressions) -> Bool {
        
        return isValid(input: text, matchesWith: regex.rawValue)
    }
    
    func isValidConfirm(password : String, confirmPassword : String) -> Bool{
        if password == confirmPassword {
            return true
        } else {
            return false
        }
    }
    
    //------------------------------------------------------
}
func showAlertMessage(title: String, message: String, okButton: String, controller: UIViewController, okHandler: (() -> Void)?){
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
            if okHandler != nil {
                okHandler!()
            }
        }
        alertController.addAction(dismissAction)
       // UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
        controller.present(alertController, animated: true, completion: nil)
    }
 
}
