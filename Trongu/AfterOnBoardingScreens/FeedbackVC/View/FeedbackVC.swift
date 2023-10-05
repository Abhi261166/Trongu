//
//  FeedbackVC.swift
//  Trongu
//
//  Created by apple on 04/07/23.
//

import UIKit
import GrowingTextView

class FeedbackVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource {
  

    
    @IBOutlet weak var btnSendFeedback: UIButton!
    @IBOutlet weak var txtFldFeedBackType: UITextField!
    @IBOutlet weak var txtVwFeedback: GrowingTextView!
    
    var viewModel:FeedbackVM?
    let pickerView = UIPickerView()
    var selectedId = ""
    var selectedType = ""
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setViewModel()
        txtFldFeedBackType.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        txtFldFeedBackType.inputView = pickerView
        
        
       
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
        isSelected = false
    }
    
    func setViewModel(){
        
        self.viewModel = FeedbackVM(observer: self)
        
    }
    
    func apiCall(){
        
        self.viewModel?.apiFeedbackTypes()
    }
    
   
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendFeedbackAction(_ sender: UIButton) {
       
        if txtFldFeedBackType.text == ""{
            
           // Singleton.shared.showErrorMessage(error: "Please select feedback type", isError: .error)
            Singleton.shared.showAlert(message: "Please select feedback type", controller: self, Title: "Feedback")
            
        }else if txtVwFeedback.text == ""{
           // Singleton.shared.showErrorMessage(error: "Please add feedback", isError: .error)
            Singleton.shared.showAlert(message: "Please add feedback", controller: self, Title: "Feedback")
            
        }else{
            self.viewModel?.apiSendFeedback(feedback: txtVwFeedback.text.trim, feedback_category: self.selectedId)

        }
        
        
    }
   
        
        // MARK: - UIPickerViewDataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Number of columns in the picker view
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.viewModel?.arrFeedbackTypes.count ?? 0 // Number of rows in the picker view
        }
        
        // MARK: - UIPickerViewDelegate
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.viewModel?.arrFeedbackTypes[row].name // Data to display in each row
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // Handle the selection here, e.g., update the text field with the selected option
            selectedType = self.viewModel?.arrFeedbackTypes[row].name ?? ""
            selectedId = self.viewModel?.arrFeedbackTypes[row].id ?? ""
            // If needed, you can also resign the first responder to dismiss the picker view
           // txtFldFeedBackType.resignFirstResponder()
            
            self.isSelected = true
            
            
        }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isSelected{
            txtFldFeedBackType.text = selectedType
        }else{
            txtFldFeedBackType.text = self.viewModel?.arrFeedbackTypes[0].name
            selectedId = self.viewModel?.arrFeedbackTypes[0].id ?? ""
        }
        
        
    }
    
}

extension FeedbackVC:FeedbackVMObserver{
    
    func observeFeedbackSentSucessfull() {
        let vc = FeedbackPopUpVC()
        vc.completion = {
            self.popVC()
        }
        vc.modalPresentationStyle = .overFullScreen
        present(vc, true)
        
    }
    
    func observeFeedbackTypesSucessfull() {
        
        print("FeedBack Types --",self.viewModel?.arrFeedbackTypes.count ?? 0)
        
    }
    
}
