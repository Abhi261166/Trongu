//
//  UIButton+Custom.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 01/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIButton {
    
    var title:String? {
        return self.titleLabel?.text
    }
    
    func setMenuButton(controller: UIViewController) {
//        let revealController = controller.revealViewController()
//        controller.revealViewController()?.rearViewRevealOverdraw = 0.0
//        if revealController != nil {
//            self.addTarget(revealController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//            controller.view.addGestureRecognizer(controller.revealViewController().tapGestureRecognizer())
//            controller.view.addGestureRecognizer(controller.revealViewController().panGestureRecognizer())
//        }
    }
    
    func setBackButton(controller: UIViewController) {
        self.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        self.addTarget(controller, action: #selector(controller.popVC) , for: .touchUpInside)
    }
    
    
    func setTitleWithBottomView(selected: UIColor, unselected: UIColor, selectView: UIColor, unselectView: UIColor, height:CGFloat) {
        self.subviews.forEach { (view) in
            if view.accessibilityIdentifier == "bottomLine" {
                view.removeFromSuperview()
            }
        }
        self.setTitleColor(selected, for: .selected)
        self.setTitleColor(unselected, for: .normal)
        let lineView = UIView(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: height))
        lineView.accessibilityIdentifier = "bottomLine"
        lineView.backgroundColor =  self.isSelected ? selectView  : unselectView
        self.addSubview(lineView)
    }
    
    @IBInspectable public var imageTintColor:UIColor?  {
        set (color) {
            let img = self.imageView?.image?.renderTemplateMode
            self.setImage(img, for: state)
            self.tintColor = color
        } get {
            if let color = self.tintColor {
                return color
            } else {
                return nil
            }
        }
    }
    
    func addTarget(target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    var underline: Void {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setCustomButton(title:String, titleColor:UIColor, bgColor:UIColor, font:UIFont) {
        self.layer.cornerRadius = 3.0
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    func setCustomButtonWithBorder(title:String?, titleColor:UIColor, bgColor:UIColor, font: FONT_NAME, fontSize:CGFloat, roundCorner:CGFloat = 0, borderWidth:CGFloat = 0, borderColor:UIColor = UIColor.lightGray) {
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(font, fontSize)
        self.layer.cornerRadius = roundCorner
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func setCustomButtonFont(font: FONT_NAME, fontSize:CGFloat, roundCorner:CGFloat = 0, borderWidth:CGFloat = 0, borderColor:UIColor = UIColor.lightGray) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(font, fontSize)
        self.layer.cornerRadius = roundCorner
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
    }
    
    
    func setButton(title:String?, titleColor:UIColor, unselected:UIColor, bgColor:UIColor, font: FONT_NAME, fontSize:CGFloat) {
        self.backgroundColor = bgColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(unselected, for: .selected)
        self.titleLabel?.font = UIFont.setCustom(font, fontSize)
    }
    
    func setTitle(selected:UIColor, unselected:UIColor) {
        self.setTitleColor(selected, for: .selected)
        self.setTitleColor(unselected, for: .normal)
    }
    
    
    func setCustomAttributedButtonWithBorder(title:NSMutableAttributedString, bgColor:UIColor, borderColor:UIColor, borderWidth:CGFloat) {
        self.setAttributedTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    open func setButton(enabled isEnable:Bool) {
        self.isEnabled = isEnable
        UIView.animate(withDuration: 0.25) {
            if isEnable == true {
                self.backgroundColor = UIColor.blackishColor
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font as Any])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    func setTitleImage() {
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width), bottom: 5, right: 20)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
    }
    
    func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
    
    func alignImageRight() {
        if let titleLabel = self.titleLabel,let imageView = self.imageView {
            // Force the label and image to resize.
            titleLabel.sizeToFit()
            imageView.sizeToFit()
            imageView.contentMode = .scaleAspectFit
            
            // Set the insets so that the title appears to the left and the image appears to the right.
            // Make the image appear slightly off the top/bottom edges of the button.
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 1 * imageView.frame.size.width,
                bottom: 0,
                right:imageView.frame.size.width)
            self.imageEdgeInsets = UIEdgeInsets(
                top: 4,
                left: frame.size.width-imageView.frame.size.width,
                bottom: 4,
                right: 20)
        }
    }
    
    
    
    
    func setButton(_ title:String, _ titleColor:UIColor, _ bgColor:UIColor, _ image:UIImage? = nil, _ tintColor:UIColor = .white, _ font:FONT_NAME, _ size:CGFloat, corners:CGFloat = 0) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
        let img = image?.renderTemplateMode
        self.setImage(img, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(font, size)
        self.tintColor = tintColor
        self.cornerRadius = corners
    }
    
    func setButtonTitle(_ title:String?, _ titleColor:UIColor, _ bgColor:UIColor,  _ font:FONT_NAME, _ size:CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
        self.titleLabel?.lineBreakMode = .byCharWrapping
        self.titleLabel?.font = UIFont.setCustom(font, size)
    }
    
    func setButtonSelectedUnselected(_ title:String,_ isSelected:Bool) {
        let color:UIColor = isSelected == true ? UIColor.themeColor : UIColor.placeholderColor
        self.isSelected = isSelected
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.setCustom(.Cinzel_Regular, 14)
        self.setTitleColor(color, for: .normal)
    }
    
    func setImage(_ image:UIImage, withTint color:UIColor, for state: UIControl.State = UIControl.State.normal) {
        let img = image.renderTemplateMode
        self.setTitle("", for: state)
        self.setImage(img, for: state)
        self.tintColor = color
    }
    
    func setButtonSelectedUnselected(_ image:UIImage,_ isSelected:Bool) {
        let img = image.renderTemplateMode
        self.isSelected = isSelected
        self.setTitle("", for: .normal)
        self.setImage(img, for: .normal)
    }
    
    func setButtonTitleImage(left:CGFloat, right:CGFloat, image:UIImage) {
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        let width = self.frame.size.width
        self.setImage(right: right, image: image, width: width)
    }
    
    func setImage(right:CGFloat, image:UIImage, width:CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        self.addSubview(imageView)
        let xPoint = (width-right) - (image.size.width/2)
        let yPoint = frame.height/2
        imageView.center = CGPoint(x: xPoint, y: yPoint)
        
    }
    
    
    open func setLabel() {
        self.setImage(#imageLiteral(resourceName: "cartWhiteIcon"), for: .normal)
        self.subviews.forEach { view in
            if let label = view as? UILabel {
                if (label.text?.count ?? 0) > 0 {
                    print("tag remove cart button")
                    view.removeFromSuperview()
                }
            }
        }
        if let cartItems = UserDefaults.standard.value(forKey: "cartItems") as? String, cartItems != "0" {
            let label = UILabel(frame: CGRect(x: 12, y: 10, width: 20, height: 20))
            label.setLabel(cartItems, .white, .Cinzel_Regular, 12)
            label.backgroundColor = .systemRed
            label.textAlignment = .center
            label.cornerRadius = 10.0
            label.borderColor = .white
            label.borderWidth = 1
            self.addSubview(label)
            self.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15)
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
}

extension UISegmentedControl {
    func setSegmentStateTitles(titles:[String],font:FONT_NAME,size:CGFloat){
        for (index,title) in titles.enumerated(){
            let font = UIFont.setCustom(font, size)
            self.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            self.setTitle(title, forSegmentAt: index)
        }
        self.selectedSegmentIndex = 0
        self.tintColor = .red
    }
}
