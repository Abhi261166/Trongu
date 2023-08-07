//
//  UITextField.swift
//  MyPadi
//
//  Created by apple on 24/08/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


protocol CustomTextFieldDelegate: UITextFieldDelegate {
    func textField(_ textField: UITextField, didDeleteBackwardAnd wasEmpty: Bool)
}

class CustomTextField: UITextField {
//    var customDelegate:CustomTextFieldDelegate?
    
    override func deleteBackward() {
        // see if text was empty
        let wasEmpty = text == nil || text! == ""
        // then perform normal behavior
        super.deleteBackward()
        
        // now, notify delegate (if existent)
//        self.customDelegate?.textField(self, didDeleteBackwardAnd: wasEmpty)
        (delegate as? CustomTextFieldDelegate)?.textField(self, didDeleteBackwardAnd: wasEmpty)
    }
    
}

