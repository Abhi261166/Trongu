//
//  KeyboardVM.swift
//  fit
//
//  Created by Abhishek Jaiswal on 15/05/21.
//

import UIKit


protocol KeyboardVMObserver: NSObjectProtocol {
    func keyboard(didChange height: CGFloat, duration: Double, animation: UIView.AnimationOptions)
}

class KeyboardVM {
    weak var keyboardObserver: KeyboardVMObserver?
    
    public func setKeyboardNotification(_ keyboardObserver: KeyboardVMObserver?) {
        self.keyboardObserver = keyboardObserver
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    public func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        keyboardObserver = nil
    }
    
    @objc func keyboardWillShow(_ notification : Foundation.Notification) {
        DispatchQueue.main.async {
            var duration = 0.3
            var animation = UIView.AnimationOptions.curveLinear
            if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                duration = value
            }
            if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                animation = UIView.AnimationOptions(rawValue: value)
            }
            let value: NSValue = (notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let height = value.cgRectValue.height
            let barHight = HEIGHT.getBottomInsetofSafeArea
            self.keyboardObserver?.keyboard(didChange: height-barHight, duration: duration, animation: animation)
        }
    }
    
    @objc func keyboardDidChangeFrame(_ notification : Foundation.Notification) {
        DispatchQueue.main.async {
            var duration = 0.3
            var animation = UIView.AnimationOptions.curveLinear
            if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                duration = value
            }
            if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                animation = UIView.AnimationOptions(rawValue: value)
            }
            let value: NSValue = (notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let height = value.cgRectValue.height
            let barHight = HEIGHT.getBottomInsetofSafeArea
            self.keyboardObserver?.keyboard(didChange: height-barHight, duration: duration, animation: animation)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        DispatchQueue.main.async {
            var duration = 0.3
            var animation = UIView.AnimationOptions.curveLinear
            if let value  = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                duration = value
            }
            if let value = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                animation = UIView.AnimationOptions(rawValue: value)
            }
            self.keyboardObserver?.keyboard(didChange: 0, duration: duration, animation: animation)
        }
    }
}
