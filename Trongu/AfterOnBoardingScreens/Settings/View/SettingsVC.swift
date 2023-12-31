//
//  SettingsVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit
import SafariServices

class SettingsVC: UIViewController, LogoutVMObserver {
    
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var settings = ["Contact Us","Change Password","About Us","Terms & Conditions","Feedback","Private account","Blocked","Delete Account","Logout"]
    var setting2 = ["Contact Us","About Us","Terms & Conditions","Feedback","Private account","Blocked","Delete Account","Logout"]
    var viewModel: LogoutVM?
    var viewModel2:SettingsVM?
    var isprivate = false
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        self.settingsTableView.register(UINib(nibName: "SettingsTVCell", bundle: nil), forCellReuseIdentifier: "SettingsTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    
    func setViewModel() {
        self.viewModel = LogoutVM(observer: self)
        self.viewModel2 = SettingsVM(observer: self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func observeLogoutSucessfull() {
        removeLocalStorage()
    }
    
    func removeLocalStorage(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.userDataKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.userIdKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.accessTokenKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.learnReasonKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.spanishLevelKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.dailyGoalKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.learnReasonContinueKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.spanishLevelContinueKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.dailyGoalContinueKey)
        
        UIView.animate(withDuration: 0.3) {
            Singleton.shared.gotoLogin()
        }
    }
}
extension SettingsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaultsCustom.getUserData()?.login_type == "0"{
            
            return setting2.count
        }else{
            return settings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVCell", for: indexPath) as! SettingsTVCell
        if UserDefaultsCustom.getUserData()?.login_type == "0"{
            cell.titleLabel.text = setting2[indexPath.row]
       
        }else{
            cell.titleLabel.text = settings[indexPath.row]
        }
        
        cell.imgNext.isHidden = false
        
        if UserDefaultsCustom.getUserData()?.login_type == "0"{
            if indexPath.row == 4{
                cell.imgNext.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isEnabled = true
                cell.btnSwitch.tag = indexPath.row
                cell.btnSwitch.isSelected = isprivate
                cell.btnSwitch.addTarget(self, action: #selector(actionSwitchPublicPrivate),for: .touchUpInside)
            }
            
        }else{
            if indexPath.row == 5{
                cell.imgNext.isHidden = true
                cell.btnSwitch.tag = indexPath.row
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isEnabled = true
                cell.btnSwitch.isSelected = isprivate
                cell.btnSwitch.addTarget(self, action: #selector(actionSwitchPublicPrivate),for: .touchUpInside)
                
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaultsCustom.getUserData()?.login_type == "0"{
            
            switch indexPath.row {
            case 0:
                print("contact us")
              
                if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/contactus")
                {
                    let safariCC = SFSafariViewController(url: url)
                    present(safariCC, animated: true, completion: nil)
                }
        
            case 1:
                print("about us")
                if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/aboutus")
                {
                    let safariCC = SFSafariViewController(url: url)
                    present(safariCC, animated: true, completion: nil)
                }
                
            case 2:
                
                print("sdsddefwsd")
                if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/termsandconditions")
                {
                    let safariCC = SFSafariViewController(url: url)
                    present(safariCC, animated: true, completion: nil)
                }
                
            case 3:
            //    print("sdsdsd")
            
                let vc = FeedbackVC()
                vc.hidesBottomBarWhenPushed = true
                self.pushViewController(vc, true)
            case 4:
                print("Private Account")
                
                
            case 5:
                print("AboutUs")
                let vc = BlockedVC()
                vc.hidesBottomBarWhenPushed = true
                //             vc.privacyTitle = "About Us"
                //             vc.termlink = API.aboutlink
                self.pushViewController(vc, true)
            case 6:
                print("InTerms")
                let alertController = UIAlertController(title: "Delete Account", message: "Are you sure, you want to delete account?", preferredStyle: .alert)
                
                // Create an action to add to the alert controller
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let actionDelete = UIAlertAction(title: "Delete Account", style: .destructive) { (_) in
                    self.viewModel2?.apiDeleteAccount()
                }
                // Add the action to the alert controller
                alertController.addAction(actionCancel)
                alertController.addAction(actionDelete)
                // Present the alert controller
                present(alertController, animated: true, completion: nil)
                
            case 7:
                // Create an instance of UIAlertController with a title, message, and preferred style
                print("Logout Account")
                // Create an instance of UIAlertController with a title, message, and preferred style
                let alertController = UIAlertController(title: "Logout", message: "Are you sure, you want to logout?", preferredStyle: .alert)
                
                // Create an action to add to the alert controller
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let actionLogout = UIAlertAction(title: "Logout", style: .destructive) { (_) in
                    self.viewModel?.apiLogout()
                }
                // Add the action to the alert controller
                alertController.addAction(actionCancel)
                alertController.addAction(actionLogout)
                // Present the alert controller
                present(alertController, animated: true, completion: nil)
                
            default:
                break
            }
            
        }else{
            
            switch indexPath.row {
            case 0:
                print("contact us")
              
                if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/contactus")
                {
                    let safariCC = SFSafariViewController(url: url)
                    present(safariCC, animated: true, completion: nil)
                }
                
            case 1:
                let vc = ChangePswrdVC()
                vc.hidesBottomBarWhenPushed = true
                self.pushViewController(vc, true)
                print("ChangePassword")
            case 2:
                print("about us")
                if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/aboutus")
                {
                    let safariCC = SFSafariViewController(url: url)
                    present(safariCC, animated: true, completion: nil)
                }
                
            case 3:
                if let url = URL(string:"http://161.97.132.85/j1/trongu/frontend/web/trongu/termsandconditions")
                {
                    let safariCC = SFSafariViewController(url: url)
                    present(safariCC, animated: true, completion: nil)
                }
                print("sdsddefwsd")
            case 4:
                print("sdsdsd")
                             let vc = FeedbackVC()
                             vc.hidesBottomBarWhenPushed = true
                             self.pushViewController(vc, true)
            case 5:
                print("Private Account")
                
            case 6:
                print("AboutUs")
                let vc = BlockedVC()
                vc.hidesBottomBarWhenPushed = true
                //             vc.privacyTitle = "About Us"
                //             vc.termlink = API.aboutlink
                self.pushViewController(vc, true)
            case 7:
                print("InTerms")
                let alertController = UIAlertController(title: "Delete Account", message: "Are you sure, you want to delete account?", preferredStyle: .alert)
                
                // Create an action to add to the alert controller
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let actionDelete = UIAlertAction(title: "Delete Account", style: .destructive) { (_) in
                    self.viewModel2?.apiDeleteAccount()
                }
                // Add the action to the alert controller
                alertController.addAction(actionCancel)
                alertController.addAction(actionDelete)
                // Present the alert controller
                present(alertController, animated: true, completion: nil)
                
            case 8:
                // Create an instance of UIAlertController with a title, message, and preferred style
                print("Logout Account")
                // Create an instance of UIAlertController with a title, message, and preferred style
                let alertController = UIAlertController(title: "Logout", message: "Are you sure, you want to logout?", preferredStyle: .alert)
                
                // Create an action to add to the alert controller
                let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let actionLogout = UIAlertAction(title: "Logout", style: .destructive) { (_) in
                    self.viewModel?.apiLogout()
                }
                // Add the action to the alert controller
                alertController.addAction(actionCancel)
                alertController.addAction(actionLogout)
                // Present the alert controller
                present(alertController, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    @objc func actionSwitchPublicPrivate(sender:UIButton){
        
        self.viewModel2?.apiPublicPrivate(index: sender.tag)
        
    }
    
}

extension SettingsVC:SettingsVMObserver{
    
    func observeAcountDeletedSucessfull() {
        removeLocalStorage()
    }
    
    
    func observeSwitchPublicPrivateSucessfull(index:Int) {
        isprivate.toggle()
        settingsTableView.reload(row: index)
    }
    
}
