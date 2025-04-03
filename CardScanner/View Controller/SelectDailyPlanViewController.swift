//
//  SelectDailyPlanViewController.swift
//  CardScanner
//
//  Created by Frontend on 19/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class SelectDailyPlanViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    @IBOutlet weak var dateDailyPlan: UITextField!
    @IBOutlet weak var unitDailyPlan: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var buttonContinuar: UIButton!
    
    var unitPicker: UIPickerView!
    var unitDataPicker: [Unit]!
    var unitPikcerValue: Unit!;
    var start_date: Date!;
    var end_date: Date!;
    var activityView: UIActivityIndicatorView?
    
    var dateUnitValue: Date!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalData.sharedInstance.dailyPlan = nil;
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true;
        toolBar.tintColor = UIColor(red:253/255, green:127/255, blue:133/255, alpha: 1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        unitPicker = UIPickerView();
        unitPicker.delegate = self;
        unitPicker.dataSource = self;
        unitDailyPlan.inputView = unitPicker;
        unitDailyPlan.inputAccessoryView = toolBar;
        
        errorLabel.isHidden = true;
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        activityView?.startAnimating()
        
        self.view.addSubview(activityView!)
        
        Unit.getUnit(onSuccess:{
            data in
            
            print(data)
            
            guard let start_date = data["start_date"] else {
                print(data["start_date"]!, "is Null")
                return
               
            }
            
            guard let end_date = data["end_date"] else {
                print(data["end_date"]!, "is Null")
                return
            }
            
            print(start_date)
            print(end_date)
            
           self.start_date = GlobalData.CreateDate(stringDate: start_date as! String )
           self.end_date = GlobalData.CreateDate(stringDate: end_date as! String )
          
       
            var datePicker: UIDatePicker {
                let picker  = UIDatePicker();
                
                picker.datePickerMode = .date;
                picker.minimumDate = self.start_date
                picker.maximumDate = self.end_date
                
                picker.addTarget(self, action: #selector(self.datePickerChanged(_:)), for: .valueChanged)
                return picker;
            }
            
            self.dateDailyPlan.inputView = datePicker;
            self.dateDailyPlan.inputAccessoryView = toolBar;
            
            print("Dates", self.end_date)
            
            self.unitDataPicker = data["units"]! as? [Unit];
            self.unitPikcerValue =  self.unitDataPicker[0]
            self.unitDailyPlan.text = self.unitPikcerValue.unit_number;
        
            
            self.dateDailyPlan.text = GlobalData.DateToString(date: Date(), format: "MMM dd,yyyy")
            
            self.unitDailyPlan.isEnabled = true;
            self.dateDailyPlan.isEnabled = true;
            self.buttonContinuar.isEnabled = true;
            
            print(data["agencies"]!)
            
            
            GlobalData.sharedInstance.agencies = data["agencies"]! as? [GlobalData.row]
            
            
            print( GlobalData.sharedInstance.agencies!)
         
            
            self.activityView?.hidesWhenStopped = true;
            self.activityView?.stopAnimating();
            
        }, onFailure: {
            error in
                print(error)
        })

        // Do any additional setup after loading the view.
    }
    @IBAction func OnCancelButton(_ sender: Any) {
         performSegue(withIdentifier: "unwindToPassword", sender: self);
    }
    
    @IBAction func OnClickContinueButton(_ sender: Any){
        dateUnitValue = GlobalData.CreateDate(stringDate: dateDailyPlan.text!, format: "MMM dd,yyyy")
        
        
        
        
        let endDate: Date = self.unitPikcerValue.end_date!;
        
        print(dateUnitValue)
        print(endDate)
        
        if(dateUnitValue > endDate){
            self.errorLabel.isHidden = false;
        }else{
            self.errorLabel.isHidden = true;
            let dateDaily = GlobalData.CreateDate(stringDate: dateDailyPlan.text!, format: "MMM dd,yyyy")
            
            GlobalData.sharedInstance.unit_number =  "\(self.unitPikcerValue.unit_number ?? "" )";
            GlobalData.sharedInstance.unit =  "\(self.unitPikcerValue.id ?? 0)";
            GlobalData.sharedInstance.date = GlobalData.DateToString(date: dateDaily)
            
            performSegue(withIdentifier: "SelectArrivalSegue", sender: self);
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToSelectDailyPlan(segue:UIStoryboardSegue) { }

}

extension SelectDailyPlanViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.unitDataPicker!.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.unitPikcerValue = self.unitDataPicker[row];
        return self.unitPikcerValue.unit_number;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitDailyPlan.text = self.unitPikcerValue.unit_number;
    }
    
    @objc func donePicker (sender:UIBarButtonItem){
        self.view.endEditing(true)
    }
    /*
    var datePicker: UIDatePicker {
        let picker  = UIDatePicker();
        
        picker.datePickerMode = .date;
        
        //let start_date = GlobalData.CreateDate(stringDate: "2019-04-01" )
        //picker.minimumDate = start_date
        
        
        print("Iniciar todo")
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        return picker;
    }
 */
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter();
        formatter.dateStyle =  .medium;
        formatter.timeStyle = .none;
        return formatter;
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker){
        self.dateDailyPlan.text = GlobalData.DateToString(date: sender.date, format: "MMM dd,yyyy")
        //dateDailyPlan.text = dateFormatter.string(from: sender.date);
        _ = dateDailyPlan.isValid();
    }
}
