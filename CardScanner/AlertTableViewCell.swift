//
//  AlertTableViewCell.swift
//  CardScanner
//
//  Created by Pablo A Aguero m on 22/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import EasyTipView



class AlertTableViewCell: UITableViewCell{
    
    @IBOutlet weak var character_rol_input: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ContactPhone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var agency: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var character_role: UILabel!
    @IBOutlet weak var scenes_play: UILabel!
    @IBOutlet weak var checkintime: UILabel!
    @IBOutlet weak var notes_input: UITextField!
    @IBOutlet weak var address: UILabel!
    

    
    @IBOutlet weak var ErrorButton: UIButton!
    @IBOutlet weak var MainContentView: UIView!
    @IBOutlet weak var checkOT: UISwitch!
    @IBOutlet weak var checkstatus_input: UITextField!
    
    var characterPicker: UIPickerView!;
    var characterDataPicker: [GlobalData.row]!;
    var characterPickerValue: Characters!
    var characters: [Characters]!
    
    var checkStatusPicker: UIPickerView!;
    var checkStatusDataPicker: [GlobalData.row]!;
    var checkStatusPickerValue: GlobalData.row!
    
    
    var person: Person!;
    var character: Characters!;
    
    var characters_actor: String = "";
    
    var indexPath: IndexPath!;
    weak var delegate: AlertCellDelegate?
    
    var preferences = EasyTipView.Preferences();
    
    @IBAction func OnEditNotes(_ sender: UITextField) {
        self.character.talent?[0].notes = sender.text
        Characters.saveInfoExtra(character: character, onSuccess: {
            isSave in
            print(isSave)
            
        }, onFailure: {
            error in
            print(error)
        })
    }
    
    @IBAction func OnChangeOT(_ sender: UISwitch) {
        
         self.character.talent?[0].ot = sender.isOn
             Characters.saveInfoExtra(character: character, onSuccess: {
             isSave in
             print(isSave)
             
             }, onFailure: {
             error in
             print(error)
         })
    }
    
    @IBAction func OnErrorButtonClick(_ sender: Any) {
        let array_character_actors = characters_actor.components(separatedBy: ",")
        
        self.showToolTip(text: array_character_actors.joined(separator: "\n"))
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        characters = GlobalData.sharedInstance.myDailyPlan?.characters
        
        preferences.drawing.font = UIFont(name: "Raleway", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.gray
        preferences.drawing.textAlignment = .left
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true;
        toolBar.tintColor = UIColor(red:253/255, green:127/255, blue:133/255, alpha: 1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        characterPicker = UIPickerView();
        characterPicker.delegate = self;
        characterPicker.dataSource = self;
        
        character_rol_input.inputView = characterPicker
        character_rol_input.inputAccessoryView = toolBar
        
        
        
        checkStatusDataPicker = [
            GlobalData.row(id: "", value: "", text: "Select", parent: 0),
            GlobalData.row(id: "16", value: "Check", text: "Check", parent: 0),
            GlobalData.row(id: "17", value: "Reject", text: "Reject", parent: 0),
        ]
        
        checkStatusPicker = UIPickerView();
        checkStatusPicker.delegate = self;
        checkStatusPicker.dataSource = self;
        checkstatus_input.inputView = checkStatusPicker;
        checkstatus_input.inputAccessoryView = toolBar
        
        checkOT.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
     
        
    }
    
    
    func drawCell(character: Characters, index: IndexPath){
        
        nameLabel.text = character.talent?[0].name?.uppercased();
        ContactPhone.text = character.talent?[0].phone
        email.text = character.talent?[0].email?.uppercased()
        agency.text = character.talent?[0].agency?.uppercased()
        dob.text = GlobalData.DateToString(date: (character.talent?[0].date_of_birth!)!, format: "MM/dd/YYYY", changeTimezone:false)
        
        //character_role.text = character.characterName
        character_rol_input.text = character.characterName?.uppercased()
        scenes_play.text = character.talent?[0].scenas_player
        characters_actor = (character.talent?[0].characters_actor!)!
        
       // if let _character_list = character.talent?[0].characters_actor{
         //   print(_character_list)
           // if _character_list == ""{
                ErrorButton.isHidden = characters_actor==""
            //}
        //}

        //nameLabel.text = "\(ErrorButton.isHidden)\(characters_actor=="") \(characters_actor) \(nameLabel.text)"
        let date = GlobalData.CreateDate(stringDate: (character.talent?[0].check_time)!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        
        checkintime.text =  GlobalData.DateToString(date: date, format: "h:mm a", changeTimezone: true)
        
        
        checkOT.isOn = character.talent?[0].ot ?? false
        notes_input.text = character.talent?[0].notes
        
      
        
        if let i = checkStatusDataPicker.firstIndex(where: { $0.id == character.talent?[0].check_status }){
            
            print(i)
            
            self.checkStatusPickerValue = checkStatusDataPicker![i];
            checkstatus_input.text = checkStatusPickerValue.value
            
            
            if(checkStatusPickerValue.id == "17"){
                self.checkstatus_input.backgroundColor =  UIColor(red: 255/255, green: 64/255, blue: 64/255, alpha: 0.2)
            }else if(checkStatusPickerValue.id == "16"){
                self.checkstatus_input.backgroundColor =  UIColor(red: 189/255, green: 244/255, blue: 179/255, alpha: 0.7)
            }else{
                self.checkstatus_input.backgroundColor =  UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        
        
        self.character = character;
        self.indexPath = index;
    }

  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
}

extension AlertTableViewCell: EasyTipViewDelegate{
    
    
    
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        //
    }
    
    func showToolTip(text:String){
        let tipView = EasyTipView(text: text, preferences: self.preferences, delegate: self)
        
        tipView.show(forView: self.ErrorButton, withinSuperview: self.MainContentView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: { tipView.dismiss() })
    }
}


extension AlertTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == characterPicker{
            return characters!.count;
        }
        
        if pickerView == checkStatusPicker{
            return checkStatusDataPicker!.count;
        }
        
        return 0;
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == characterPicker{
            return characters![row].characterName;
        }
        
        if pickerView == checkStatusPicker{
            return checkStatusDataPicker![row].value
        }
        
        return nil
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
      //Action Save
        
        if pickerView == characterPicker{
            characterPickerValue = characters![row]
            self.character_rol_input.text = characterPickerValue.characterName
            
            self.character.id = characterPickerValue.id
            
            Characters.saveInfoExtra(character: character, onSuccess: {
                isSave in
                self.delegate?.refreshTable()
                print(isSave)
                
            }, onFailure: {
                error in
                print(error)
            })
        }
        
        if pickerView == checkStatusPicker{
            self.checkStatusPickerValue = checkStatusDataPicker![row];
            checkstatus_input.text = checkStatusPickerValue.value
            
            self.character.talent?[0].check_status = checkStatusPickerValue.id
            Characters.saveInfoExtra(character: character, onSuccess: {
                isSave in
                 self.delegate?.refreshTable()
                print(isSave)
                
            }, onFailure: {
                error in
                print(error)
            })
        }
        
       
        
        
    }
    
    
    @objc func donePicker (sender:UIBarButtonItem){
        self.endEditing(true)
    }
}
