//
//  ReleaseTextViewController.swift
//  CardScanner
//
//  Created by Frontend on 4/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit



class ReleaseTextViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var releaseView: UITextView!
    
    var embeddScrollView: AgreementViewController!
    var delegateRelease: ReleaseScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let person: Person = GlobalData.sharedInstance.person!
        var address = "";
        var date_sign_guardian = "";
        var day_sign_guardian = "";
        var month_sign_guardian = "";
        var day_year_sign_guardian = "";
        
        
        
        if let isMenor = person.isMenor{
            print("IS MENOR: ", isMenor)
            
            var directionArray: Array<String> = [];
            
            if (isMenor){
                
                directionArray.append("\(person.guardian?.address ?? "") \(person.guardian?.unit ?? "")")
                directionArray.append((person.guardian?.city)!)
                directionArray.append((person.guardian?.stateString)!)
               
                if((person.guardian?.postalCode) != nil && (person.guardian?.postalCode) != ""){
                    directionArray.append((person.guardian?.postalCode)!)}
                directionArray.append((person.guardian?.country)!)
            } else{
                

                directionArray.append("\(person.address ?? "") \(person.unit ?? "")")
                directionArray.append(person.city!)
                directionArray.append(person.stateString!)
                
                if((person.postalCode) != nil && (person.postalCode) != ""){
                    directionArray.append(person.postalCode!)}
                
                directionArray.append(person.country!)
            }
            
            address = directionArray.joined(separator: ", ")
        }
        
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.month,.year], from: Date())
        
        let dateFormatter =  DateFormatter();
        dateFormatter.dateFormat = "MMM, yyyy";
        date_sign_guardian = dateFormatter.string(from: Date());
        
        dateFormatter.dateFormat = "dd, yyyy";
        day_year_sign_guardian = dateFormatter.string(from: Date())
        
        
        if let day = components.day {
            let dayString = String(day)
            day_sign_guardian = dayString
        }
        
        if let month = components.month {
            let monthString = String(month)
            month_sign_guardian = monthString
        }
        
        let params : NSMutableDictionary = [
            "agency_name": person.agency,
            "talent_name": person.name! + " " + person.middleName! + " " + person.lastName!,
            "project_name": GlobalData.sharedInstance.myDailyPlan?.productionName as! String,
            "talent_start_date": GlobalData.DateToString(date: Date()),
            "production_end_date": GlobalData.DateToString(date: (GlobalData.sharedInstance.myDailyPlan?.endDate)!),
            "date_of_signature": GlobalData.DateToString(date: Date(),  format: "MM/dd/YYYY"),
            "date_of_birth": "",
            "address": address,
            "date_of_birth": GlobalData.DateToString(date: person.birthday!, format: "MM/dd/YYYY"),
            "date_guardian_sing": "",
            "guardian_name": (person.guardian?.name!)! + " " + (person.guardian?.middleName!)! + " " + (person.guardian?.lastName!)!,
            "phone_guardian": person.guardian?.phone as! String,
            "day": day_sign_guardian,
            "month": month_sign_guardian,
            "month_year": date_sign_guardian,
            "day_year": day_year_sign_guardian
            
        ]
        
        let str = NSMutableAttributedString();
        
        str.append(self.readFile(name_file: "release", params: params));
        
        if let isMenor = person.isMenor{
            if isMenor{
                str.append(self.readFile(name_file: "guardian_release", params: params));
            }
        }
        
        releaseView.attributedText = str;
        releaseView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func readFile(name_file:String, params: NSMutableDictionary) -> NSMutableAttributedString{
        var _attributedStringWithRtf: NSMutableAttributedString = NSMutableAttributedString();
        if let rtfPath = Bundle.main.url(forResource: name_file, withExtension: "rtf") {
            do {
                
                let attributedStringWithRtf:NSMutableAttributedString = try NSMutableAttributedString(url: rtfPath, options: [.documentType : NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                
                for key in params.allKeys{
                    let regex = try! NSRegularExpression(pattern: "\\(@\(key)@\\)");
                    let range = NSRange(0..<attributedStringWithRtf.string.utf16.count);
                    let matches = regex.matches(in: attributedStringWithRtf.string, range: range)
                    
                    for match in matches.reversed(){
                        attributedStringWithRtf.replaceCharacters(in: match.range, with: "\(params[key] ?? "")")
                    }
                }
                
                _attributedStringWithRtf = attributedStringWithRtf;
                
            } catch let error {
                print("Got an error \(error)")
            }
        }
        
        return _attributedStringWithRtf
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= ((scrollView.contentSize.height - scrollView.frame.size.height))) {
            delegateRelease?.completeScroll(complete: true);
            print("BOTTOM")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func stoppedScrolling() {
        print("Scroll finished")
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? AgreementViewController,
            segue.identifier == "EmbedSegue"{
            self.embeddScrollView = vc;
        }
    }
    

}

