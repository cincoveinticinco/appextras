//
//  PersonalInfoViewController.swift
//  CardScanner
//
//  Created by 525 on 1/12/17.
//  Copyright © 2017 525. All rights reserved.//
//

import UIKit
import ImagePicker
import Validator



class PersonalInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var actualScroll: CGFloat = 0;
    let patterName: String = "[a-z A-Z\\d\\s]{1,30}";
    let patterCodeZip: String = "[0-9]{1,6}";
    let patterPhone: String = "[\\d]{1,16}";
    let patterAddress: String = "[a-zA-Z0-9ÁáÀàÉéÈèÍíÌìÓóÒòÚúÙùÜüÑñ#_()@:,.\\-\\–_/ ]+";
    let patterCity: String = "[[a-zA-Z ]+";
    
    
    // Validation Rules
    let emailRule = ValidationRulePattern(pattern: "^([a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)", error: validationError("Email address is invalid"));
    var emailRules = ValidationRuleSet<String>()
    
    let managerRule  = ValidationRulePattern(pattern: "[a-zA-Z0-9ÁáÀàÉéÈèÍíÌìÓóÒòÚúÙùÜüÑñ#_()@:,.\\-\\–_/ ]{1,50}", error: validationError("Field invalid"))
    var manageRules = ValidationRuleSet<String>()
    
    let alphaRule = ValidationRulePattern(pattern: "([a-z A-ZÁáÀàÉéÈèÍíÌìÓóÒòÚúÙùÜüÑñ\\s]){0,30}", error: validationError("Field invalid"))
    var alphaReqRules = ValidationRuleSet<String>()
    var alphaRules = ValidationRuleSet<String>()
 
    let requiredRule = ValidationRulePattern(pattern: "^(\\w|\\s|\\S)+$", error: validationError("Invalid field"));
    var requiredRules = ValidationRuleSet<String>();
    
    let numberRule = ValidationRulePattern(pattern: "^[0-9]*$", error: validationError("Field invalid"))
    var numberRules = ValidationRuleSet<String>();
    
    let phoneRule = ValidationRulePattern(pattern: "[\\d]{1,10}", error: validationError("Field invalid"));
    var phoneRuleSet = ValidationRuleSet<String>()
    
    let zipCodeRule = ValidationRulePattern(pattern: "[0-9]{0,6}", error: validationError("Field invalid"));
    var zipCodeRuleSet = ValidationRuleSet<String>()
    
    let addressRule = ValidationRulePattern(pattern: "[a-zA-Z0-9ÁáÀàÉéÈèÍíÌìÓóÒòÚúÙùÜüÑñ#_()@:,.\\-\\–_/ ]+", error: validationError("Field invalid"));
    var addressRuleSet = ValidationRuleSet<String>()
    
    let cityRule = ValidationRulePattern(pattern: "[a-z A-Z\\d\\s]{1,30}", error: validationError("Field invalid"));
    var cityRuleSet = ValidationRuleSet<String>()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var artisticNameField: UITextField!
    @IBOutlet weak var middleTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var agencyTextField: UITextField!
    @IBOutlet weak var codeCountryField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var dOBTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    
    @IBOutlet weak var ageRangeTextField: UITextField!
    
    // GUARDIAN DATA
    @IBOutlet weak var nameGuardianTextField: UITextField!
    @IBOutlet weak var middleGuardianTextField: UITextField!
    @IBOutlet weak var lastNameGuardianTextField: UITextField!
    @IBOutlet weak var codeCountryGuardianField: UITextField!
    @IBOutlet weak var phoneGuardianField: UITextField!
    @IBOutlet weak var emailGuardianField: UITextField!
    @IBOutlet weak var addressGuardianTextField: UITextField!
    @IBOutlet weak var unitGuardianTextField: UITextField!
    @IBOutlet weak var countryGuardianField: UITextField!
    @IBOutlet weak var cityGuardianTextField: UITextField!
    @IBOutlet weak var stateGuardianTextField: UITextField!
    @IBOutlet weak var zipCodeGuardianTextField: UITextField!
    
    @IBOutlet weak var viewDataTalent: UIView!
    @IBOutlet weak var viewDataGuardian: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var lblError: UILabel!
    
   
    
    
    // Pickers
    //var stateDataPicker: [(id: Int, value:String, text: String?)]!;
    var stateDataAll: [GlobalData.row]!;
    var stateDataPicker: [GlobalData.row]!;
    var stateDataPickerValue: GlobalData.row!
    var statePicker: UIPickerView!;
    
    var agencyPicker: UIPickerView!;
    var agencyDataPicker: [GlobalData.row]!;
    var agencyPickerValue: GlobalData.row!
    
    var ageRangePicker: UIPickerView!;
    var ageRangeDataPicker:  [GlobalData.row]!;
    var ageRangePickerValue: GlobalData.row!
    
 
    
    var genreDataPicker:  [GlobalData.row] = [
            GlobalData.row(id: "0", value: "", text: "", parent: 0),
            GlobalData.row(id: "2", value: "FEMALE", text: "FEMALE", parent: 0),
            GlobalData.row(id: "1", value: "MALE", text: "MALE", parent: 0),
            GlobalData.row(id: "3", value: "OTHER", text: "OTHER", parent: 0)
    ];
    
    var genreDataPickerValue: GlobalData.row!;
    var genrePicker: UIPickerView!;
    
    var countryDataPicker: [GlobalData.row] = [GlobalData.row(id:"1", value:"United States", text: "", parent: 0), GlobalData.row(id:"2", value:"Mexico", text: "", parent: 0)];
    var countryDataPickerValue: GlobalData.row = GlobalData.row(id:"1", value:"United States", text:"", parent: 0);
    var countryPicker: UIPickerView!;
    
    var activityView: UIActivityIndicatorView?
    
    
    //Attributes
    
    var person: Person = GlobalData.sharedInstance.person!;
    
    var isSubmit: Bool = false;
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewWillDisappear(_ animated: Bool){
        NotificationCenter.default.removeObserver(self);
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        
        statePicker = UIPickerView();
        statePicker.dataSource = self;
        statePicker.delegate = self;
        
        genrePicker = UIPickerView();
        genrePicker.dataSource = self;
        genrePicker.delegate = self;
        
        ageRangePicker = UIPickerView();
        ageRangePicker.dataSource = self;
        ageRangePicker.delegate = self;
        
        countryPicker = UIPickerView();
        countryPicker.dataSource = self;
        countryPicker.delegate = self;
        
        agencyPicker = UIPickerView();
        agencyPicker.dataSource = self;
        agencyPicker.delegate = self;
        
        person.isMenor = false;
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        activityView?.startAnimating()
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 70, height: 50))
        text.center.x = self.view.center.x;
        text.center.y = self.view.center.y + 30;
        text.textColor = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        text.textAlignment = .center;
        text.text = "Loading"
        self.view.addSubview(text)
        self.view.addSubview(activityView!)
        
        
        
        GlobalData.sharedInstance.getTalentData(onSuccess: {
            lists in
            self.scrollView.isHidden = false;
            self.activityView?.hidesWhenStopped = true;
            self.activityView?.stopAnimating();
            text.isHidden = true;
            
                self.stateDataAll = lists.states;
                self.stateDataPicker = self.stateDataAll.filter({ $0.parent == 1 })
                self.agencyDataPicker = GlobalData.sharedInstance.agencies
                self.ageRangeDataPicker = lists.ranges
            
            if  self.person.birthday != nil{
                self.ageRangePickerValue = self.getAgeRange(birthday: self.person.birthday!);
                
                
                
                if(Int(self.ageRangePickerValue.id) != 0){
                    self.ageRangeTextField.text = self.ageRangePickerValue.value;
                    print(self.ageRangePickerValue.id)
                }
            }
           
            
            
                self.stateDataPickerValue = self.getState(state: "FL");
                self.stateTextField.text = self.stateDataPickerValue.value;
            
                if let state = self.person.state {
                    self.stateDataPickerValue = self.getState(state: state);
                    self.stateTextField.text = self.stateDataPickerValue.value;
                }
            
            self.stateTextField.isEnabled = true;
            self.ageRangeTextField.isEnabled = true;
            self.stateTextField.background = nil;
            self.ageRangeTextField.background = nil;
            
            
        }, onFailure: {
            error in
                print(error.localizedDescription)
        })
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true;
        toolBar.tintColor = UIColor(red:253/255, green:127/255, blue:133/255, alpha: 1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        agencyTextField.inputView = agencyPicker
        agencyTextField.inputAccessoryView  = toolBar
        
        dOBTextField.inputView = datePicker;
        dOBTextField.inputAccessoryView = toolBar
        
        stateTextField.inputView = statePicker
        stateTextField.inputAccessoryView = toolBar
        
        stateGuardianTextField.inputView = statePicker;
        stateGuardianTextField.inputAccessoryView = toolBar
        
        genreTextField.inputView = genrePicker;
        genreTextField.inputAccessoryView = toolBar;
        
        countryField.inputView = countryPicker
        countryField.inputAccessoryView = toolBar;
        countryGuardianField.inputView = countryPicker
        countryGuardianField.inputAccessoryView = toolBar;
        
        ageRangeTextField.inputView = ageRangePicker;
        
        
        ageRangeTextField.inputAccessoryView = toolBar;
        
        //signatureView.delegate = self
        nameTextField.text = person.name
        middleTextField.text = person.middleName
        lastNameTextField.text = person.lastName
        addressTextField.text = person.address
        cityTextField.text = person.city
        zipCodeTextField.text = person.zip
        
        if person.birthday != nil {
            dOBTextField.text = GlobalData.DateToString(date: person.birthday!, format: "MMM dd,yyyy")  //dateFormatter.string(from: person.birthday);
        }
        
        print("GENDER:");
        
        
        let gender = person.gender ?? "";
        print(person.gender ?? "")
        
        if gender == "M"{
           genreDataPickerValue = genreDataPicker[2]
           genreTextField.text = genreDataPickerValue.value
        }else if gender == "F"{
            genreDataPickerValue = genreDataPicker[1]
            genreTextField.text = genreDataPickerValue.value
        }
        
        
        countryField.text = countryDataPickerValue.value;
        countryGuardianField.text = countryDataPickerValue.value;
        
         self.subscribeValidation()
        
        print("search talent")
        
        
        if person.name != nil && person.lastName != nil && person.birthday != nil {
            person.getInfoTalent(onSuccess: {
                json in
                print(json)
                
                if !json["error"].boolValue {
                    
                    let actor = json["actor"][0];
                    
                    print(actor)
                    
                    self.artisticNameField.text = "";
                    self.agencyTextField.text = actor["name_agency"].stringValue;
                    self.phoneField.text = actor["phone"].stringValue;
                    self.emailField.text = actor["email"].stringValue;
                    
                    self.nameGuardianTextField.text = actor["guardian_name"].stringValue;
                    self.artisticNameField.text = actor["artistic_name"].stringValue;
                    self.middleGuardianTextField.text = actor["guardian_middle_name"].stringValue;
                    self.lastNameGuardianTextField.text = actor["guardian_last_name"].stringValue;
                    self.phoneGuardianField.text = actor["guardian_phone"].stringValue;
                    self.emailGuardianField.text = actor["guardian_email"].stringValue;
                    self.countryGuardianField.text = actor["guardian_county"].stringValue;
                    self.cityGuardianTextField.text = actor["guardian_city"].stringValue;
                    self.zipCodeGuardianTextField.text = actor["guardian_postal_code"].stringValue;
                    self.addressGuardianTextField.text = actor["guardian_address"].stringValue;
                    self.stateGuardianTextField.text = actor["guardian_state_id"].stringValue;
                    
                }else{
                    print("NUEVO")
                }
                
            }, onFailure: {
                error in
                print(error)
            })
        }
        
       
        
    }
    
    func subscribeValidation() {
        requiredRules.add(rule: requiredRule)
        emailRules.add(rule: emailRule)
        
        alphaRules.add(rule: alphaRule)
        alphaReqRules.add(rule: alphaRule)
        alphaReqRules.add(rule: requiredRule)
        
        numberRules.add(rule: numberRule);
        numberRules.add(rule: requiredRule)
        
        manageRules.add(rule: managerRule);
        phoneRuleSet.add(rule: phoneRule);
        zipCodeRuleSet.add(rule: zipCodeRule)
        addressRuleSet.add(rule: addressRule)
        cityRuleSet.add(rule: cityRule)
        
        
        //self.nameTextField.setValidationRule(rules: alphaReqRules);
        self.nameTextField.validationRules = alphaReqRules
        self.nameTextField.validationHandler = self.nameTextField.OnValidationHandler;
        self.nameTextField.validateOnInputChange(enabled: true)
        
        //self.middleTextField.setValidationRule(rules: alphaRules);
        self.middleTextField.validationRules = alphaRules
        self.middleTextField.validationHandler = self.middleTextField.OnValidationHandler;
        self.middleTextField.validateOnInputChange(enabled: true)
        
        //self.lastNameTextField.setValidationRule(rules: alphaReqRules);
        self.lastNameTextField.validationRules = alphaReqRules
        self.lastNameTextField.validationHandler = self.lastNameTextField.OnValidationHandler;
        self.lastNameTextField.validateOnInputChange(enabled: true)
        
        //self.artisticNameField.setValidationRule(rules: alphaRules);
        self.artisticNameField.validationRules = alphaRules
        self.artisticNameField.validationHandler = self.artisticNameField.OnValidationHandler;
        self.artisticNameField.validateOnInputChange(enabled: true)
        
        //self.agencyTextField.setValidationRule(rules: manageRules);
        self.agencyTextField.validationRules = manageRules
        self.agencyTextField.validationHandler = self.agencyTextField.OnValidationHandler;
        self.agencyTextField.validateOnInputChange(enabled: true)
        
        //self.phoneField.setValidationRule(rules: phoneRuleSet);
        self.phoneField.validationRules = phoneRuleSet
        self.phoneField.validationHandler = self.phoneField.OnValidationHandler;
        self.phoneField.validateOnInputChange(enabled: true)
        
        //self.emailField.setValidationRule(rules: emailRules);
        self.emailField.validationRules = emailRules
        self.emailField.validationHandler = self.emailField.OnValidationHandler;
        self.emailField.validateOnInputChange(enabled: true)
        
        //self.ageRangeTextField.setValidationRule(rules: requiredRules)
        self.ageRangeTextField.validationRules = requiredRules
        self.ageRangeTextField.validationHandler = self.ageRangeTextField.OnValidationHandler;
        self.ageRangeTextField.validateOnInputChange(enabled: true)
        
        //self.dOBTextField.setValidationRule(rules: requiredRules)
        self.dOBTextField.validationRules = requiredRules
        self.dOBTextField.validationHandler = self.dOBTextField.OnValidationHandler;
        self.dOBTextField.validateOnInputChange(enabled: true)
        
        //self.addressTextField.setValidationRule(rules: addressRuleSet)
        self.addressTextField.validationRules = addressRuleSet
        self.addressTextField.validationHandler = self.addressTextField.OnValidationHandler;
        self.addressTextField.validateOnInputChange(enabled: true)
        
        //self.countryField.setValidationRule(rules: alphaReqRules)
        self.countryField.validationRules = alphaReqRules
        self.countryField.validationHandler = self.countryField.OnValidationHandler;
        self.countryField.validateOnInputChange(enabled: true)
        
        //self.genreTextField.setValidationRule(rules: requiredRules)
        self.genreTextField.validationRules = requiredRules
        self.genreTextField.validationHandler = self.genreTextField.OnValidationHandler;
        self.genreTextField.validateOnInputChange(enabled: true)
        
        //self.stateTextField.setValidationRule(rules: requiredRules)
        self.stateTextField.validationRules = requiredRules
        self.stateTextField.validationHandler = self.stateTextField.OnValidationHandler;
        self.stateTextField.validateOnInputChange(enabled: true)
        
        //self.cityTextField.setValidationRule(rules: cityRuleSet)
        self.cityTextField.validationRules = cityRuleSet
        self.cityTextField.validationHandler = self.cityTextField.OnValidationHandler;
        self.cityTextField.validateOnInputChange(enabled: true)
        
        //self.zipCodeTextField.setValidationRule(rules: zipCodeRuleSet)
        self.zipCodeTextField.validationRules = zipCodeRuleSet
        self.zipCodeTextField.validationHandler = self.zipCodeTextField.OnValidationHandler;
        self.zipCodeTextField.validateOnInputChange(enabled: true)
        
        
        
        //self.nameGuardianTextField.setValidationRule(rules: alphaReqRules);
        self.nameGuardianTextField.validationRules = alphaReqRules
        self.nameGuardianTextField.validationHandler = self.nameGuardianTextField.OnValidationHandler;
        self.nameGuardianTextField.validateOnInputChange(enabled: true)
        
        //self.middleGuardianTextField.setValidationRule(rules: alphaRules);
        self.middleGuardianTextField.validationRules = alphaRules
        self.middleGuardianTextField.validationHandler = self.middleGuardianTextField.OnValidationHandler;
        self.middleGuardianTextField.validateOnInputChange(enabled: true)
        
        //self.lastNameGuardianTextField.setValidationRule(rules: alphaReqRules);
        self.lastNameGuardianTextField.validationRules = alphaReqRules
        self.lastNameGuardianTextField.validationHandler = self.lastNameGuardianTextField.OnValidationHandler;
        self.lastNameGuardianTextField.validateOnInputChange(enabled: true)
        
        //self.phoneGuardianField.setValidationRule(rules: phoneRuleSet);
        self.phoneGuardianField.validationRules = phoneRuleSet
        self.phoneGuardianField.validationHandler = self.phoneGuardianField.OnValidationHandler;
        self.phoneGuardianField.validateOnInputChange(enabled: true)
        
        //self.emailGuardianField.setValidationRule(rules: emailRules);
        self.emailGuardianField.validationRules = emailRules
        self.emailGuardianField.validationHandler = self.emailGuardianField.OnValidationHandler;
        self.emailGuardianField.validateOnInputChange(enabled: true)
        
        //self.countryGuardianField.setValidationRule(rules: alphaReqRules);
        self.countryGuardianField.validationRules = alphaReqRules
        self.countryGuardianField.validationHandler = self.countryGuardianField.OnValidationHandler;
        self.countryGuardianField.validateOnInputChange(enabled: true)
        
        //self.cityGuardianTextField.setValidationRule(rules: alphaReqRules);
        self.cityGuardianTextField.validationRules = alphaReqRules
        self.cityGuardianTextField.validationHandler = self.cityGuardianTextField.OnValidationHandler;
        self.cityGuardianTextField.validateOnInputChange(enabled: true)
        
        
        //self.zipCodeGuardianTextField.setValidationRule(rules: zipCodeRuleSet);
        self.zipCodeGuardianTextField.validationRules = zipCodeRuleSet
        self.zipCodeGuardianTextField.validationHandler = self.zipCodeGuardianTextField.OnValidationHandler;
        self.zipCodeGuardianTextField.validateOnInputChange(enabled: true)
        
        self.addressGuardianTextField.setValidationRule(rules: addressRuleSet)
        self.addressGuardianTextField.validationRules = addressRuleSet
        self.addressGuardianTextField.validationHandler = self.addressGuardianTextField.OnValidationHandler;
        self.addressGuardianTextField.validateOnInputChange(enabled: true)
        
        //self.stateGuardianTextField.setValidationRule(rules: requiredRules)
        self.stateGuardianTextField.validationRules = requiredRules
        self.stateGuardianTextField.validationHandler = self.stateGuardianTextField.OnValidationHandler;
        self.stateGuardianTextField.validateOnInputChange(enabled: true)
        
        
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
    
    func validateForm() -> Bool{
        var errors: Bool = true;
        _ = getAllTextFields(fromView: self.view).map{
            
            if($0.isEnabled){
                let result = $0.isValid()
                print(result)
                if(!result){
                    errors = false;
                }
            }
            
        }
        return errors
    }
    
    func  checkValidateForm() -> Bool{
        var errors: Bool = true;
        _ = getAllTextFields(fromView: self.view).map{
            
            if($0.isEnabled){
                let result = $0.isValid()
                print(result)
                if(!result){
                    errors = false;
                }
            }
            
        }
        return errors
    }
    
 
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnContinueButton(_ sender: Any) {
        self.isSubmit = true
        let _person = Person();
        let _guardian = Person();
        
            lblError.isHidden = false
            lblError.text = "Form invalid"
        
            if(validateForm()){
                if validateDoB(birthday: dOBTextField.text!, currDate: GlobalData.CreateDate(stringDate: dOBTextField.text!, format: "MMM dd,yyyy")) {
                
                _person.id = ""
                _person.name = nameTextField.text!;
                _person.middleName = middleTextField.text!;
                _person.lastName = lastNameTextField.text!;
                _person.artisticName = artisticNameField.text!;
                
                print(dOBTextField.text!)
                if((dOBTextField.text) != ""){
                    _person.birthday = GlobalData.CreateDate(stringDate: dOBTextField.text!, format: "MMM dd,yyyy");
                }
                
                
                _person.age = 0;
                _person.age_range = ageRangePickerValue.id;
                _person.isMenor = person.isMenor;
                _person.address = addressTextField.text!;
                _person.unit = unitTextField.text!;
                _person.country = countryField.text!;
                _person.city = cityTextField.text!;
                _person.state = String(stateDataPickerValue.id);
                _person.stateString = stateTextField.text!
                _person.zip = zipCodeTextField.text!;
                    
                
                
                _person.postalCode = zipCodeTextField.text!;
                _person.countryCode = codeCountryField.text!;
                _person.phone = phoneField.text!;
                _person.email = emailField.text!;
                _person.gender = String(genreDataPickerValue.id);
                _person.agency = agencyTextField.text!;
                
                _guardian.name = nameGuardianTextField.text!
                _guardian.middleName = middleGuardianTextField.text!
                _guardian.lastName = lastNameGuardianTextField.text!
                _guardian.countryCode = codeCountryGuardianField.text!
                _guardian.phone = phoneGuardianField.text!
                _guardian.email = emailGuardianField.text!
                _guardian.address = addressGuardianTextField.text!
                _guardian.unit = unitGuardianTextField.text!
                _guardian.country = countryGuardianField.text!
                _guardian.city = cityGuardianTextField.text!
                _guardian.state = String(stateDataPickerValue.id);
                _guardian.stateString = stateGuardianTextField.text!
                _guardian.postalCode = zipCodeGuardianTextField.text!
                
                _person.guardian = _guardian;
                
                lblError.isHidden = true
                    
                    let characters = GlobalData.sharedInstance.myDailyPlan?.characters;
                    _ = "";
                    for character in characters!{
                        let talent  = character.talent;
                        
                        for t in talent!{
                            let calendar = Calendar.current
                            
                            let year_t = calendar.component(.year, from: t.date_of_birth!)
                            let month_t = calendar.component(.month, from: t.date_of_birth!)
                            let day_t = calendar.component(.day, from: t.date_of_birth!)
                            
                            let year_p = calendar.component(.year, from: _person.birthday!)
                            let month_p = calendar.component(.month, from: _person.birthday!)
                            let day_p = calendar.component(.day, from: _person.birthday!)
                            
                            let birth_t = "\(year_t)-\(month_t)-\(day_t)";
                            let birth_p = "\(year_p)-\(month_p)-\(day_p)";
                            
                            if t.name!.trimmingCharacters(in: .whitespacesAndNewlines) == _person.name?.trimmingCharacters(in: .whitespacesAndNewlines) && t.last_name!.trimmingCharacters(in: .whitespacesAndNewlines) == _person.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) && birth_t == birth_p{
                                GlobalData.sharedInstance.characterHasId = (t.characterHasTalentId)!
                                _person.isStored = true;
                                
                               
                                
                                print("exist", GlobalData.sharedInstance.characterHasId);
                            }else{
                               
                            }
                        }
                    }
                    
                    if(_person.isStored){
                         performSegue(withIdentifier: "ErrorDaySegue", sender: self)
                    }else{
                        GlobalData.sharedInstance.person = _person;
                        performSegue(withIdentifier: "segueRol", sender: self);
                    }
                
                    
                    
         
                
            }else{
                lblError.isHidden = false
                lblError.text = "Birthday date invalid"
                print("Form invalid!!");
            }
        }else{
            lblError.text = "Form invalid"
            lblError.isHidden = false;
        }
        
        
        
        
       
    }
    
    @IBAction func OnCancelButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToScanDriverLicence", sender: self)
    }
    
     @IBAction func unwindToFormData(segue:UIStoryboardSegue) { }
    
}


extension PersonalInfoViewController{
    
    var datePicker: UIDatePicker {
        let picker  = UIDatePicker();
        if person.birthday != nil{
            picker.setDate(person.birthday!, animated: false)
        }
        picker.datePickerMode = .date;
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        return picker;
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter();
        formatter.dateStyle =  .medium;
        formatter.timeStyle = .none;
        return formatter;
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker){
        self.dOBTextField.text = GlobalData.DateToString(date: sender.date, format: "MMM dd,yyyy")
        //dOBTextField.text = dateFormatter.string(from: sender.date);
        print(ageRangePickerValue)
        
        let months = Calendar.current.dateComponents([.weekOfYear, .month], from: sender.date, to: Date())
        print(months.month!, months.weekOfYear!)
        
        if validateDoB(birthday: dOBTextField.text!, currDate: sender.date) {
            _ = dOBTextField.isValid();
            lblError.isHidden = true;
        }else{
            lblError.text = "Birthday date invalid"
            lblError.isHidden = false;
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statePicker{
            return stateDataPicker!.count;
        }else if pickerView == ageRangePicker{
            return ageRangeDataPicker.count;
        } else if pickerView == countryPicker{
            return countryDataPicker.count
        }else if pickerView == genrePicker{
            return genreDataPicker.count
        }else{
            return agencyDataPicker!.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == statePicker{
            return stateDataPicker![row].value
        }else if pickerView == ageRangePicker{
            return ageRangeDataPicker![row].value;
        }else if pickerView == countryPicker{
            return countryDataPicker[row].value;
        }else if pickerView == genrePicker{
            return genreDataPicker[row].value;
        }else{
            return agencyDataPicker?[row].value
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == statePicker{
            self.stateDataPickerValue = stateDataPicker![row];
            stateTextField.text = stateDataPicker![row].value
            stateGuardianTextField.text = stateDataPicker![row].value
            
            _ = stateTextField.isValid();
            _ = stateGuardianTextField.isValid();
            
        }else if pickerView == ageRangePicker{
            
            if Int(self.ageRangeDataPicker![row].id) == 1 {
                //self.dOBTextField.isEnabled = true;
                self.viewDataGuardian.isHidden = false;
                self.viewDataTalent.isHidden = true;
                updatePositionView(view: viewButtons, x: 0, y: 1120)
                
                _ = getAllTextFields(fromView: self.viewDataGuardian).map{
                    $0.isEnabled = true;
                }
                
                _ = getAllTextFields(fromView: self.viewDataTalent).map{
                    $0.isEnabled = false;
                }
            
                self.codeCountryGuardianField.isEnabled = false;
                self.person.isMenor = true;
                
                
            }else{
                self.person.isMenor = false;
                self.viewDataGuardian.isHidden = true;
                self.viewDataTalent.isHidden = false;
                updatePositionView(view: viewButtons, x: 0, y: 930)
                
                _ = getAllTextFields(fromView: self.viewDataGuardian).map{
                    $0.isEnabled = false;
                }
                
                _ = getAllTextFields(fromView: self.viewDataTalent).map{
                    if self.codeCountryField != $0{
                        $0.isEnabled = true;
                        
                    }
                }
            }
            
            self.ageRangePickerValue = ageRangeDataPicker![row];
            ageRangeTextField.text = ageRangeDataPicker![row].value
            _ = ageRangeTextField.isValid();
        }else if pickerView == countryPicker{
            self.countryDataPickerValue = countryDataPicker[row];
            
            
            let fillStates = self.stateDataAll.filter({ $0.parent == Int(self.countryDataPickerValue.id) })
            self.stateDataPicker = fillStates;
            
            self.stateDataPickerValue = nil;
            stateTextField.text = ""
            stateGuardianTextField.text = ""
            
            countryField.text = countryDataPicker[row].value;
            countryGuardianField.text = countryDataPicker[row].value;
            
            
        }else if pickerView == agencyPicker{
          
            self.agencyPickerValue = agencyDataPicker[row];
            agencyTextField.text = agencyDataPicker[row].value
            _ = agencyTextField.isValid();
        }else{
            print("GENRE", genreDataPicker[row].value)
            self.genreDataPickerValue = genreDataPicker[row];
            genreTextField.text = genreDataPicker[row].value
            _ = genreTextField.isValid();
        }
    }
    
    
    @objc func donePicker (sender:UIBarButtonItem){
        self.view.endEditing(true)
        print(self.genreDataPickerValue);
        if(dOBTextField.text != ""){
            if validateDoB(birthday: dOBTextField.text!, currDate: GlobalData.CreateDate(stringDate: dOBTextField.text!, format: "MMM dd,yyyy")) {
                lblError.isHidden = true;
            }else{
                lblError.text = "Birthday date invalid"
                lblError.isHidden = false;
            }
        }
        
        
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        //handle appearing of keyboard here
        
        self.actualScroll = scrollView.contentOffset.y;
        if let firstResponder = self.findFirstResponder(inView: self.view) {
            let offset = firstResponder.superview!.frame.minY
            let inputOffset = firstResponder.frame.minY + 20
            
            if self.person.isMenor! {
                if offset > 410 && scrollView.contentOffset.y < 340{
                    scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y+inputOffset), animated: true)
                }
            } else{
                if offset > 630 && scrollView.contentOffset.y < 20{
                    print(scrollView.contentOffset.y);
                    print(offset)
                    scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y+inputOffset), animated: true)
                }
            }
        }
        
        
        
        
      
        
        
    }
    
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }

            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }

        return nil
    }
    
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        //handle dismiss of keyboard here
        //Utils.showMessage("FINISH.CONNECTED", message: "\(scrollView.contentOffset.y)")
        scrollView.setContentOffset(CGPoint(x: 0, y: self.actualScroll), animated: true)
        
        if let firstResponder = self.findFirstResponder(inView: self.view) as? UITextField{
            print(firstResponder)
            print(firstResponder.isValid());
            
            if(self.isSubmit){
                if(!validateForm()){
                    lblError.isHidden = false
                    lblError.text = "Form invalid"
                }else{
                    lblError.isHidden = true
                    lblError.text = "Form invalid"
                }
            }
        }
        
        
        
        
        
        
    }
}

extension PersonalInfoViewController{
    struct ValidationError: Error {
        public let message: String
        public init(message m: String) {
            message = m
        }
    }
    
    func updatePositionView(view: UIView, x: CGFloat, y: CGFloat){
        
        let yPosition = y == 0 ? view.frame.origin.y : y
        let xPosition = x == 0 ? view.frame.origin.x : x
        
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        UIView.animate(withDuration: 1.0, animations: {
            view.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        })
    }
    
    func getAgeRange(birthday: Date) -> GlobalData.row{
        
        let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year!
        
        var ageRange: GlobalData.row = GlobalData.row(id: "0", value: "", text: "", parent: 0);
        
        print(age)
        
        print("RANGES")
        print(ageRangeDataPicker)
        
        
        switch age {
        case 1..<18:
            print("Under 18")
           ageRange = ageRangeDataPicker[1]
        case 18...20:
            ageRange = ageRangeDataPicker[2]
            print("18 - 20")
        case 21...30:
            ageRange = ageRangeDataPicker[3]
            print("21 - 30")
        case 31...40:
            ageRange = ageRangeDataPicker[4]
            print("31 - 40")
        case 41..<100:
            ageRange = ageRangeDataPicker[5]
            print("Over 41")
        default:
            print("Not age")
        }
        
        print(ageRange)
        
        return ageRange;
        
    }
    
    func validateDoB(birthday: String, currDate: Date) -> Bool{
        
        if self.ageRangePickerValue == nil{
            return false;
        }
        
        print("BoD",birthday);
        print("CurrD",currDate);
        print("D",Date());
        print(self.ageRangePickerValue);
        let calendar = Calendar.current
        let year_t = calendar.component(.year, from: Date())
        let month_t = calendar.component(.month, from: Date())
        let day_t = calendar.component(.day, from: Date())
        
        let year_p = calendar.component(.year, from: currDate)
        let month_p = calendar.component(.month, from: currDate)
        let day_p = calendar.component(.day, from: currDate)
        
        let birth_t = "\(year_t)-\(month_t)-\(day_t)";
        let birth_p = "\(year_p)-\(month_p)-\(day_p)";
        
        print(birth_p,birth_t )
    
        let dateBitday = GlobalData.CreateDate(stringDate: birthday, format: "MMM dd,yyyy")
        
        if(birth_t == birth_p){
            return false;
        }
        
        var minDoB: Date;
        var maxDoB: Date;
        
        
    
        switch Int(self.ageRangePickerValue.id)! {
        case 1:
                var timeInterval = DateComponents();
                timeInterval.year = 18;
                maxDoB = Date();
                minDoB = Date().getDateFor(years: -19)!
                print("Under 18")
            case 2:
                minDoB = Date().getDateFor(years: -21)!
                maxDoB = Date().getDateFor(years: -18)!
                
                print("18 - 20")
            
            case 3:
                minDoB = Date().getDateFor(years: -31)!
                maxDoB = Date().getDateFor(years: -20)!
                print("21 - 30")
            
            case 4:
                minDoB = Date().getDateFor(years: -41)!
                maxDoB = Date().getDateFor(years: -30)!
                
                print("31 - 40")
            
            case 5:
                minDoB = Date().getDateFor(years: -100)!
                maxDoB = Date().getDateFor(years: -40)!
                print("Over 41")
            
            default:
                print("Not age")
                return true
        }
        print(dateBitday, minDoB, maxDoB)
        print(dateBitday >= minDoB, dateBitday <= maxDoB)
        return dateBitday >= minDoB && dateBitday <= maxDoB
        
    }
    
    func getState(state: String) -> GlobalData.row{
        var stateReturn : GlobalData.row = GlobalData.row(id:"0", value: "", text: "", parent: 0);
        for _state in stateDataPicker{
            print(_state)
            if _state.text == state{
                stateReturn = _state;
            }
        }
        
        return stateReturn;
    }
}
