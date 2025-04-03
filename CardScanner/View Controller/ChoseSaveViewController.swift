//
//  ChoseSaveViewController.swift
//  CardScanner
//
//  Created by Frontend on 19/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class ChoseSaveViewController: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var UserIcon: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var planLbl: UILabel!
    
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelError.isHidden = true;
        self.UserIcon.isHidden = true;
        self.mainContentView.isHidden = true;
        self.buttonCancel.isHidden = true;
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        activityView?.startAnimating()
        self.view.addSubview(activityView!)
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 70, height: 50))
        text.center.x = self.view.center.x;
        text.center.y = self.view.center.y + 30;
        text.textColor = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        text.textAlignment = .center;
        text.text = "Loading"
        self.view.addSubview(text)
        
        
        
        DailyPlan.getDailyPlan(
            onSuccess: {
                    dailyPlan in
                GlobalData.sharedInstance.myDailyPlan = dailyPlan;
                self.mainContentView.isHidden = false;
                self.UserIcon.isHidden = false;
                
                self.activityView?.hidesWhenStopped = true;
                self.activityView?.stopAnimating();
                self.goBackButton.isHidden = false
                
                self.planLbl.text =  "Daily plan: \(GlobalData.sharedInstance.date!) U\(GlobalData.sharedInstance.unit_number!)"
                text.isHidden = true;
                self.planLbl.isHidden = false
                
            },
            onFailure: {
                error in
                self.labelError.isHidden = false;
                self.buttonCancel.isHidden = false;
                self.labelError.text = error
                
                self.activityView?.hidesWhenStopped = true;
                self.activityView?.stopAnimating();
                text.isHidden = true;
                self.planLbl.isHidden = true
                self.goBackButton.isHidden = true
                    
            }
        )

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func OnClickSaveArrivalButton(_ sender: Any){
        performSegue(withIdentifier: "SaveArrivalSegue", sender: self)
    }

    @IBAction func OnCancerError(_ sender: Any) {
        GlobalData.sharedInstance.dailyPlan = nil
        self.performSegue(withIdentifier: "unwindToSelectDailyPlan", sender: self);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToSelectArrival(segue:UIStoryboardSegue) { }

}
