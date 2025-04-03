//
//  ValidateTextField.swift
//  CardScanner
//
//  Created by Frontend on 27/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import Validator

class ValidateTextField: UITextField {
    
}

extension UITextField{
    @IBInspectable var padding: CGFloat{
        get {
            return leftView!.frame.size.width
        }
        
        set{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
   @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
                layer.borderWidth = 1.0
                
            } else {
                layer.borderColor = nil
                layer.borderWidth = 1.0
            }
        }
    }
    
    
    func setBorderColor(borderColor: UIColor){
        self.layer.borderColor = borderColor.cgColor;
        self.layer.borderWidth = 1.0
    }
    
    func styleError(error: Bool){
        if(error){
            self.setBorderColor(borderColor: UIColor(red:253/255, green:127/255, blue:133/255, alpha: 1.0))
        }else{
            self.setBorderColor(borderColor: UIColor.darkGray);
        }
    }
    
    func setValidationRule(rules: ValidationRuleSet<UITextField.InputType>?){
        
        //var vr = self.valid;
        
        //validationRules = rules;
        
        
        //self.validationRules = rules;
        //self.validationHandler = OnValidationHandler;
        //self.validateOnInputChange(enabled: true);
    }
    
    func OnValidationHandler(result: ValidationResult){
        
        switch result {
        case .valid:
            self.styleError(error: false);
        case .invalid(let failureErrors):
            _ = failureErrors.map({ $0.localizedDescription })
            self.styleError(error: true);
        }
    }
    
    func isValid() -> Bool{
        var isValid = true;
        
        switch self.validate(){
            case .invalid( _):
                isValid = false;
            case .valid:
                isValid = true;
        }
        
        return isValid;
    }
    
    override open var isEnabled: Bool{
        willSet{
            backgroundColor = newValue ? UIColor.white : UIColor(red:246/255, green:246/255, blue:246/255, alpha: 1.0);
        }
    }
    
    
}
