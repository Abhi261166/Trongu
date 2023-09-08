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
    @IBOutlet weak var multislider: MultiSlider!
    @IBOutlet weak var lblMaxAmount: UILabel!
    @IBOutlet weak var lblMinAmount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        multislider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }

    @objc func sliderChanged(slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        lblMaxAmount.text = "$\(Int(slider.value.last ?? 0.0))"
        lblMinAmount.text = "$\(Int(slider.value.first ?? 0.0))"
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
        popVC()
    }
    
}
