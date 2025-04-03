//
//  MenuViewController.swift
//  CardScanner
//
//  Created by Frontend on 16/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import WebKit

class MenuViewController: UIViewController{
   
    @IBOutlet weak var viewTalentButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalData.sharedInstance.dailyPlan == nil {
            self.viewTalentButton.isHidden = true;
            self.logoutButton.frame =  self.logoutButton.frame.offsetBy(dx: 0, dy: -100)
        }else{
            self.viewTalentButton.isHidden = false;
            self.logoutButton.frame =  self.logoutButton.frame.offsetBy(dx: 0, dy: 0)
        }
        
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnLogout(_ sender: Any) {
        let url = URL(string: GlobalData.sharedInstance.serverURL + "/saml/logout/1/" + GlobalData.token!)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
        }
        
        task.resume()
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
        GlobalData.sharedInstance.dispose();
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewID") as! HomeLoginViewController
        
        //self.newViewController?.pushViewController(newViewController, animated: true)
        //self.present(newViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    @IBAction func OnViewAlerts(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertsViewID") as! AlertViewCharacterViewController
        
        print("me voy")
        self.navigationController?.pushViewController(newViewController, animated: true)
     }
    
    @IBAction func OnCloseMenu(_ sender: Any) {
        //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let newViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewID") as! MenuViewController
        //self.present(newViewController, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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

extension MenuViewController{
    struct ItemMenu {
        var name: String
        var segue: String
    }
}
