//
//  HeaderViewController.swift
//  CardScanner
//
//  Created by Frontend on 3/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var viewButtons: UIView!
    
    var number: Int = 19
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadCounter(notification:)), name: .alertCount, object: nil)
        
        labelNumber.layer.masksToBounds = true;
        //labelNumber.layer.maskToBounds = true;
        labelNumber.layer.cornerRadius = 10;
        labelNumber.isHidden = false;
        labelNumber.text = "\(number)";
        
        let countAlerts = GlobalData.sharedInstance.alertPersons.count
        
            labelNumber.isHidden = !(countAlerts > 0);
            labelNumber.text = "\(countAlerts)";
        
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func OnViewAlerts(_ sender: Any) {
        self.viewButtons.isHidden = false;
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertsViewID") as! AlertsViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func OnLogoutAccount(_ sender: Any) {
        self.viewButtons.isHidden = false;
        
        let url = URL(string: GlobalData.sharedInstance.serverURL + "/saml/logout/1/" + GlobalData.token!)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            //GlobalData.sharedInstance.dispose();
            //GlobalData.sharedInstance.dispose();
            //self.performSegue(withIdentifier: "unwindToMenuWithSegue", sender: self)
        }
        
        task.resume()
        
       
    }
    
    @IBAction func OnOpenAccount(_ sender: Any) {
        //self.viewButtons.isHidden = !self.viewButtons.isHidden;
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewID") as! MenuViewController
        //let navigationController = NavigationController(rootViewController: newViewController)
        
        //self.present(navigationController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @objc func reloadCounter(notification: NSNotification){
        print(GlobalData.sharedInstance.alertPersons)
        let countAlerts = GlobalData.sharedInstance.alertPersons.count
            labelNumber.isHidden = !(countAlerts > 0);
            labelNumber.text = "\(countAlerts)";
        
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

extension Notification.Name{
    static let alertCount = Notification.Name("alertCount")
}
