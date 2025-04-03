//
//  ArrivalViewController.swift
//  CardScanner
//
//  Created by Frontend on 1/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import Darwin

class ArrivalViewController: UIViewController {

    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let person = GlobalData.sharedInstance.person;
        
        let arrivalTime = GlobalData.DateToString(date: Date(), format: "h:mm a");
        
        labelWelcome.text = "WELCOME " + (person?.name)! + " " + (person?.lastName)!;
        
        labelTime.text = "YOU HAVE BEEN REGISTERED AT " +   arrivalTime
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8), execute: {
                self.performSegue(withIdentifier: "goToHomeSegue", sender: self)
            }
        )*/
        
        
    
    }

    @IBAction func OnAccept(_ sender: Any) {
        self.performSegue(withIdentifier: "goToHomeSegue", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
