//
//  FooterViewController.swift
//  CardScanner
//
//  Created by Pablo A Aguero m on 15/11/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class FooterViewController: UIViewController {
    
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String;
        
        
        let bundle = Bundle.main.infoDictionary!["CFBundleVersion"] as? String;
        
        if(GlobalData.sharedInstance.getEnvironment() == "Production"){
                self.lblVersion.text = "VERSION \(version ?? "") (\(bundle ?? ""))"
        }else{
                self.lblVersion.text = "VERSION \(version ?? "") (\(bundle ?? "")) - \(GlobalData.sharedInstance.getEnvironment())"
        }
        
        
        // Do any additional setup after loading the view.
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
