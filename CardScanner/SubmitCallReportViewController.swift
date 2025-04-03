//
//  SubmitCallReportViewController.swift
//  CardScanner
//
//  Created by FrontEnd1 on 9/10/19.
//  Copyright © 2019 525. All rights reserved.
//

import UIKit

class SubmitCallReportViewController: UIViewController{
    @IBOutlet weak var observationText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad();
        
        observationText.layer.borderColor = UIColor.darkGray.cgColor;
        
        observationText.layer.borderWidth = 1.0
        
        
    }
    @IBAction func OnSubmit(_ sender: Any) {
        
        
    
        DailyPlan.submitExtras(observation: observationText.text, onSuccess: {
                isOk in
                    print("asdasdasd")
                    /*let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SelectDailyPlan") as! SelectDailyPlanViewController
            
                    self.navigationController?.pushViewController(newViewController, animated: true)*/
                    self.performSegue(withIdentifier: "GoToHomeSegue", sender: self);
            
        }, onFailure: {
            error in
                print(error)
        })
    }
    
    @IBAction func OnCancel(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
    }
    
}
