//
//  AlertViewCharacterViewController.swift
//  CardScanner
//
//  Created by FrontEnd1 on 9/9/19.
//  Copyright © 2019 525. All rights reserved.
//

import UIKit

protocol TableViewDelegate: class{
    func isFillTableView(isFill: Bool)
    func canSubmit(isFill: Bool)
    func loadTalent(talents: [Characters])
    func validatePassword(isvalid: Bool)
}

class AlertViewCharacterViewController: UIViewController {
    
    
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var scrollTalents: UIScrollView!
    
    @IBOutlet weak var totals_talent: UILabel!
    @IBOutlet weak var SubmitButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool){
       
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
    }
    
    
    @IBAction func OnSubmitItems(_ sender: Any) {
        
        if validateCharacterList(){
             performSegue(withIdentifier: "SubmitSegue", sender: self);
        }else{
            print("NO OK")
        }
        
    }
    
    func validateCharacterList() -> Bool{
        
        for character in GlobalData.sharedInstance.charatersSubmit{
            
            if(character.talent?[0].check_time == nil){
                return false
            }
        }
        
        return true;
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToAlertView(segue:UIStoryboardSegue) { }
    
    @IBAction func OnCloseAlerts(_ sender: Any) {
        //performSegue(withIdentifier: "selectArrivalSegue", sender: self)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AlertViewCharacterViewController: TableViewDelegate{
    func isFillTableView(isFill: Bool) {
        
      
        print("ENTRO",isFill)
        
        self.labelError.isHidden = !isFill;
        //self.SubmitButton.isHidden = !isFill
        self.scrollTalents.isHidden = !isFill
      
        
    }
    
    func loadTalent(talents: [Characters]){
        self.totals_talent.text = "TOTAL OF TALENT ENROLLED: \(talents.count)"
    }
    
    func validatePassword(isvalid: Bool){
        self.totals_talent.isHidden = !isvalid
        
    }
    
    func canSubmit(isFill: Bool) {
          print("Delegateeee 22222")
        print(isFill)
        self.SubmitButton.isEnabled = isFill
        self.SubmitButton.alpha = isFill ? 1.0 : 0.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("Talent call release")
        if segue.identifier == "EmbedTalentCallReport"{
            let vc = segue.destination as! AlertsViewController
            vc.delegateTalentCall = self;
            
           vc.view.translatesAutoresizingMaskIntoConstraints = false;
            
        }
    }
}
