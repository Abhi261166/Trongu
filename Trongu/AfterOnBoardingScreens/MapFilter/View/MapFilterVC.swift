//
//  MapFilterVC.swift
//  Trongu
//
//  Created by apple on 03/07/23.
//

import UIKit

class MapFilterVC: UIViewController {

    
    @IBOutlet weak var txtFilter: UITextField!
    
    var arrFilter:[String] = ["Select post filter type","Places visited","Added to bucket list"]
    var selectedValue:String?
   
    var completion : (( _ text:String) -> Void)?  = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPicker()
        txtFilter.text = ""
    }
    
    func setPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .white
        // self.genderButton.isUserInteractionEnabled = false
        txtFilter.inputView = pickerView
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        if txtFilter.text != ""{
            
        if let completion = completion{
            popVC()
            
            var filterBy = ""
            
            switch txtFilter.text {
            case "Places visited":
                filterBy = "1"
            case "Added to bucket list":
                filterBy = "2"
            default:
                break
            }
            completion(filterBy)
        }
        }else{
          
            Singleton.shared.showAlert(message: "Please select filter type.", controller: self, Title: "Filter")
            
        }
        
    }
    
}

extension MapFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrFilter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrFilter[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0{
            txtFilter.text = ""
        }else{
            self.selectedValue = arrFilter[row]
            txtFilter.text = self.selectedValue
            
        }
        
    }
    
}

extension MapFilterVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // txtFilter.text = arrFilter[0]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        
    }
    
    
}
