//
//  CustomPickerController.swift
//  MyPadi
//
//  Created by apple on 12/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

protocol CustomPickerControllerDelegate {
    func didSelectPicker(_ value: String, _ index:Int, _ tag:Int?, custom picker: CustomPickerController, element: Any?)
    func cancel(picker: CustomPickerController, _ tag:Int)
}

class CustomPickerController: UIViewController {
    
    @IBOutlet weak var cancelButotn: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var customPicker: UIPickerView!
    
    var delegate: CustomPickerControllerDelegate?
    var valueArray: [String]?
    var selectedIndex: Int = 0
    var tag: Int?
    var element: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customPicker.delegate = self
        customPicker.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        toolbar.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
    }

    func set(_ values:[String]?, delegate: CustomPickerControllerDelegate?, tag:Int? = 0, element: Any?) {
        self.modalPresentationStyle = .overFullScreen
        self.valueArray = values
        self.delegate = delegate
        self.tag = tag
        self.element = element
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setPickerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.customPicker.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.toolbar.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: { animated in
            self.customPicker.selectRow(self.selectedIndex, inComponent: 0, animated: false)
        })
    }
    
    func setPickerView() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.customPicker.transform = CGAffineTransform.identity
            self.toolbar.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false) {
            if let tag = self.tag {
                self.delegate?.cancel(picker: self, tag)
            }
        }
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.doneButton.isEnabled = false
        self.cancelButotn.isEnabled = false
        let selectedValue = valueArray![customPicker.selectedRow(inComponent: 0)] //valueArray[customPicker.selectedRow(inComponent: 0)])
        self.delegate?.didSelectPicker(selectedValue, customPicker.selectedRow(inComponent: 0), self.tag, custom: self, element: self.element)
    }

}

extension CustomPickerController:  UIPickerViewDelegate, UIPickerViewDataSource  {
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: valueArray?[row] ?? "")
        return attributedString
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valueArray?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}


