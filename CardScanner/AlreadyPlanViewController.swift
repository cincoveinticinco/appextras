//
//  AlreadyPlanViewController.swift
//  CardScanner
//
//  Created by Frontend on 9/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class AlreadyPlanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func OnAccept(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToSelectArrival", sender: self)
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
