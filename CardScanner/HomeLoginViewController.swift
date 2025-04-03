//
//  HomeLoginViewController.swift
//  CardScanner
//
//  Created by Frontend on 18/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class HomeLoginViewController: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet var ViewHome: UIView!
    @IBOutlet weak var ButtonHome: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        
        
         let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String;
         
         let bundle = Bundle.main.infoDictionary!["CFBundleVersion"] as? String;
        
        if(GlobalData.sharedInstance.getEnvironment() != "Production"){
            self.lblVersion.text = "VERSION \(version ?? "") (\(bundle ?? "")) - \(GlobalData.sharedInstance.getEnvironment())"
            
            if GlobalData.sharedInstance.getEnvironment() == "Testing"{
                ViewHome.backgroundColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
                
                ButtonHome.backgroundColor = UIColor(red: 24/255, green: 106/255, blue: 59/255, alpha: 1)
            }
            
            if GlobalData.sharedInstance.getEnvironment() == "Staging"{
                ViewHome.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
                
                
                ButtonHome.backgroundColor = UIColor(red: 23/255, green: 82/255, blue: 121/255, alpha: 1)
                
            }
            
            
        }else{
            self.lblVersion.text = "VERSION \(version ?? "") (\(bundle ?? ""))"
            
        }
        
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "LoginWebViewSegue", sender: self)
    }
    
    @IBAction func unwindToLoginView(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
