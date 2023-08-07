//
//  CustomButton.swift
//  meetwise
//
//  Created by Nitin Kumar on 27/09/20.
//  Copyright © 2020 Nitin Kumar. All rights reserved.
//

import UIKit

class CustomButtons: UIButton {
    
    var selectedColor: UIColor?
    var unSelectedColor:UIColor?
    
    var selectedBorderColor:UIColor?
    var unselectedBorderColor:UIColor?
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? selectedColor : unSelectedColor
            self.borderColor = isSelected ? selectedBorderColor : unselectedBorderColor
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
    }
    
    open func setSelected(color:UIColor, unselectedColor:UIColor) {
        self.selectedColor = color
        self.unSelectedColor = unselectedColor
        self.isSelected = false
    }
    
    open func setSelected(titleColor:UIColor, unselectedColor:UIColor) {
        self.setTitleColor(titleColor, for: .selected)
        self.setTitleColor(unselectedColor, for: .normal)
    }
    
    open func setSelected(borderColor:UIColor, unselectedColor:UIColor) {
        self.selectedBorderColor = borderColor
        self.unselectedBorderColor = unselectedColor
    }
    
}
