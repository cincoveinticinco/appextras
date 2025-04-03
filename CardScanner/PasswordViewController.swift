//
//  PasswordViewController.swift
//  CardScanner
//
//  Created by Frontend on 2/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import Validator

class PasswordViewController: UIViewController, UITextFieldDelegate{
    
    let requiredRule = ValidationRulePattern(pattern: "^(\\w|\\s|\\S){6}$", error: validationError("Invalid field"));
    var requiredRules = ValidationRuleSet<String>();

    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        
        requiredRules.add(rule: requiredRule)
        //passwordTextField.setValidationRule(rules: requiredRules)
        passwordTextField.validationRules = requiredRules
        passwordTextField.validationHandler = passwordTextField.OnValidationHandler;
        passwordTextField.validateOnInputChange(enabled: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func OnCancelPassword(_ sender: Any) {
      /*  let url = URL(string: GlobalData.sharedInstance.serverURL + "/saml/logout/1/" + GlobalData.token!)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
        }
        
        task.resume()*/
        //GlobalData.sharedInstance.dispose();
        GlobalData.logOut = true;
        
        
         //performSegue(withIdentifier: "unwindToMenu", sender: self)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebLoginViewControllerID") as! WebLoginViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func OnSavePassword(_ sender: Any) {
        
        if(validateForm()){
            GlobalData.sharedInstance.passWord = passwordTextField.text;
            performSegue(withIdentifier: "segueSelectUnit", sender: self)
        }
        
        
    }
    
    @IBAction func unwindToPassword(segue:UIStoryboardSegue) { }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacter = "1234567890";
        let allowedCharactersSet = CharacterSet(charactersIn: allowedCharacter);
        let typeCharacterSet = CharacterSet(charactersIn: string);
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        return allowedCharactersSet.isSuperset(of: typeCharacterSet) && newLength <= 6;
    }
    
    func validateForm() -> Bool{
        var errors: Bool = true;
        _ = getAllTextFields(fromView: self.view).map{
            let result = $0.isValid();
            if(!result){
                errors = false;
            }
        }
        return errors
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.flatMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
            }.flatMap({$0})
    }
    
    struct ValidationError: Error {
        public let message: String
        public init(message m: String) {
            message = m
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(_ animated: Bool){
        print(animated)
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }

}
