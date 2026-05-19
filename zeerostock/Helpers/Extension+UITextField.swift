//
//  Extension+UITextField.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit

extension UITextField {
    
    static func createTextField(
        placeholder: String,
        isSecure: Bool = false
    ) -> UITextField {
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .none
//        textField.backgroundColor = .secondarySystemBackground
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 12
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
