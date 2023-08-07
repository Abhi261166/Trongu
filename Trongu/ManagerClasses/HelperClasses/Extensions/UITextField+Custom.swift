//
//  UITextField+Custom.swift
//  EGame
//
//  Created by apple on 05/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


extension UITextView {
    
    func updatedText(range: NSRange, replacementString string: String) -> String {
        let currentString: NSString = (self.text ?? "") as NSString
        let updatedText: String = currentString.replacingCharacters(in: range, with: string) as String
        return updatedText
    }
    
}



@IBDesignable
extension UITextField {
    
//    var underline: Void {
//        if let textString = self.text {
//            let attributedString = NSMutableAttributedString(string: textString)
//            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
//            attributedText = attributedString
//        }
//    }
    
    
    func updatedText(range: NSRange, replacementString string: String) -> String {
        let currentString: NSString = (self.text ?? "") as NSString
        let updatedText: String = currentString.replacingCharacters(in: range, with: string) as String
        return updatedText
    }
    
    
    
    @IBInspectable var placeHolderTextColor: UIColor? {
        set {
            let placeholderText = self.placeholder != nil ? self.placeholder! : ""
            attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSAttributedString.Key.foregroundColor:newValue!])
        }
        get {
            return self.placeHolderTextColor
        }
    }
    
    
    func setPlaceholder(image:UIImage, text:String, color:UIColor, font:FONT_NAME, size:CGFloat) {
        
        var img = image
        if #available(iOS 13.0, *) {
            img = image.withTintColor(color, renderingMode: .alwaysTemplate)
        } else {
            img = image.maskWithColor(color: color)
        }
        self.font = UIFont.setCustom(font, size)
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: (self.font!.capHeight - img.size.height).rounded() / 2, width: img.size.width, height: img.size.height)
        attachment.image = img
        
        let mutableString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        let attributedString = NSAttributedString(string:"   \(text)", attributes: [NSAttributedString.Key.foregroundColor:color])
            
        mutableString.append(attributedString)
        self.attributedPlaceholder = mutableString
    }
    
    func setTextField(plceholder:String, delegate: UITextFieldDelegate? = nil) {
        self.setPlaceHolder(plceholder, placeholderColor: .black, font: .Cinzel_Bold, size: 18)
        self.setLeftPaddingPoints(10)
        self.setRightPaddingPoints(10)
        self.addShadow()
        self.delegate = delegate
    }
    
    func setPlaceHolder(_ text:String?, placeholderColor color:UIColor?, font:FONT_NAME, size:CGFloat) {
        self.placeholder = text
        self.placeHolderTextColor = color
        self.font = UIFont.setCustom(font, size)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPadding(amount: CGFloat, side: UITextField.SIDE) {
        switch side {
        case .right:
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        case .left:
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        case .both:
            let paddingViewL = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingViewL
            self.leftViewMode = .always
            let paddingViewR = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingViewR
            self.rightViewMode = .always
        }
    }
    
    enum SIDE {
        case right
        case left
        case both
    }

}
