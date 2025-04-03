//
//  AlertsViewController.swift
//  CardScanner
//
//  Created by Frontend on 4/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

protocol AlertCellDelegate: class { 
    func refreshTable()
}

class AlertsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var activityView: UIActivityIndicatorView?
    var lblError: UILabel?
    
    @IBOutlet weak var tableData: UITableView!
    weak var delegateTalentCall: TableViewDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactes!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
        
        
        cell.delegate = self
        cell.drawCell(character: charactes![indexPath.item], index: indexPath)
        return cell
    }
 
    
    @IBOutlet weak var tableView: UITableView!
    var persons: [Person]! = [];
    var charactes: [Characters]! = []
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        tableData.isHidden = true;
        tableView.reloadData();
        
        let alert = UIAlertController(title: "Alerts", message: "Please input 6 digit password to continue.", preferredStyle: UIAlertControllerStyle.alert);
        
        let action = UIAlertAction(title: "Accept", style: .default){
            (alertAction) in
            let textField = alert.textFields![0] as UITextField;
            if(textField.text != GlobalData.sharedInstance.passWord){
                let alert : UIAlertController  =
                    UIAlertController(
                        title: "Error",
                        message: "Invalid Password",
                        preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    GlobalData.sharedInstance.incorrectPinCounter += 1;
                    if(GlobalData.sharedInstance.incorrectPinCounter >= 3){
                        let error_alert : UIAlertController  =
                        UIAlertController(
                            title: "Error",
                            message: "You exceed the maximum number of attempts",
                            preferredStyle: .alert)
                        
                        error_alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            self.logout();
                        }))
                        
                        self.present(error_alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                
                
                
                self.present(alert, animated: true, completion: nil)
            }else{
                self.tableData.isHidden = false;
                self.delegateTalentCall?.validatePassword(isvalid: true);
            }
            
        }
        
        alert.addTextField {
            textField in
            textField.placeholder = "Enter password"
        }
        
        alert.addAction(action);
        self.present(alert, animated: true, completion: nil);
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        
        
        lblError = UILabel(frame: CGRect(x: 60, y: 0, width: 70, height: 50))
        lblError?.center.x = self.view.center.x;
        lblError?.center.y = self.view.center.y + 30;
        lblError?.textColor = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        lblError?.textAlignment = .center;
        lblError?.text = "Loading"
        
        
        persons = GlobalData.sharedInstance.alertPersons;
        self.getTalents()
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTalents(){
        DailyPlan.getCharactesPlan(onSuccess:{
            json in
            self.charactes = json
            print("*************")
            print( json)
            print("********")
            
            self.delegateTalentCall?.loadTalent(talents: self.charactes);
            
            let no_filled = self.charactes.filter{ $0.talent?[0].check_status == nil || $0.talent?[0].check_status == ""}
            
            self.delegateTalentCall?.canSubmit(isFill: no_filled.count <= 0)
            
            self.tableView.reloadData();
            GlobalData.sharedInstance.charatersSubmit = json;
            
        }
            , onFailure:{
                error in
                print("Delegate: error 0")
                self.delegateTalentCall?.isFillTableView(isFill: false)
        })
    }
    
    func logout(){
        let url = URL(string: GlobalData.sharedInstance.serverURL + "/saml/logout/1/" + GlobalData.token!)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
        }
        
        task.resume()
        GlobalData.sharedInstance.dispose();
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewID") as! HomeLoginViewController
        self.present(newViewController, animated: true, completion: nil)
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

extension AlertsViewController: AlertCellDelegate{
    func refreshTable(){
        self.getTalents();
    }
}
