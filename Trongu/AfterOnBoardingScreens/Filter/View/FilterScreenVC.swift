//
//  FilterScreenVC.swift
//  Trongu
//
//  Created by apple on 28/06/23.
//

import UIKit
import MultiSlider
class FilterScreenVC: UIViewController {
    
    @IBOutlet weak var placeTF: UITextField!
    @IBOutlet weak var numberOfDaysTF: UITextField!
    @IBOutlet weak var tripCategoryTF: UITextField!
    @IBOutlet weak var ethnicityTF: UITextField!
    @IBOutlet weak var complexityTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func validation() {
        if placeTF.text == ""{
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankPlace, view: self)
    }else if numberOfDaysTF.text == ""{
        Trongu.showAlert(title: Constants.AppName, message: Constants.blankNumberofdays, view: self)
        }else if tripCategoryTF.text == "" {
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankTripcategory, view: self)
        }else if ethnicityTF.text == "" {
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankEthnicity, view: self)
        }else if complexityTF.text == "" {
            Trongu.showAlert(title: Constants.AppName, message: Constants.blankComplexity, view: self)
        }else{
//            let vc = CheckAvailabilityScreenVC()
//            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        validation()
    }
    
}
