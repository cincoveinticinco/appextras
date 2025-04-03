//
//  ListCharacterViewController.swift
//  CardScanner
//
//  Created by Frontend on 25/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class ListCharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activityView: UIActivityIndicatorView?
    @IBOutlet var mainViewContent: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellButtonTableViewCell", for: indexPath) as! CellButtonTableViewCell
        
        cell.labelCell?.text = characters![indexPath.item].characterName?.uppercased();
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = GlobalData.sharedInstance.person;
        person?.characterId = characters![indexPath.item].id;
        
        GlobalData.sharedInstance.characterId = characters![indexPath.item].id;
        GlobalData.sharedInstance.dailyPlan = characters![indexPath.item].dailyPlanId;
        GlobalData.sharedInstance.character = characters![indexPath.item];
        
        print("character id", GlobalData.sharedInstance.characterId!)
        
     
        upladoWithoutSign()
        
        
        
    }
    
    func upladoWithoutSign(){
        
        let person = GlobalData.sharedInstance.person;
        var characters_name = "";
        
        //if(person?.isStored)!{
            activityView?.startAnimating()
            mainViewContent.isHidden = true;
            
            person?.dailyPlan = GlobalData.sharedInstance.dailyPlan
            person?.characterId = GlobalData.sharedInstance.characterId
            person?.storedPerson(
                
                onSuccess: {
                    json in
                    DispatchQueue.main.async {
                        print(json)
                        
                        
                        if(json["error"].bool == false){
                            
                            GlobalData.sharedInstance.releaseString = json["url"].stringValue;
                            self.mainViewContent.isHidden = false;
                            self.activityView?.hidesWhenStopped = true;
                            self.activityView?.stopAnimating();
                            
                            self.performSegue(withIdentifier: "ValidateCharacterSegue", sender: self);
                            
                        }else{
                            for character in json["characters"].arrayValue{
                                characters_name += "\(character["character_name"]), "
                            }
                            GlobalData.sharedInstance.characterNamePrevius = characters_name;
                            
                            
                            GlobalData.sharedInstance.alertPersons.append(person!)
                            self.performSegue(withIdentifier: "alertArriveSegueCharacter", sender: self)
                            NotificationCenter.default.post(name: .alertCount, object: nil)
                        }
                    }
            }, onFailure: {
                error in
                print(error.localizedDescription);
                //self.performSegue(withIdentifier: "arriveSegue", sender: self);
            })
        //}
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var characters = GlobalData.sharedInstance.myDailyPlan?.characters
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        tableView.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        
        self.view.addSubview(activityView!)
        
        if((characters?.count)! <= 0){
            let alert : UIAlertController  =
                UIAlertController(
                    title: "Error",
                    message: "This plan does not contain extras",
                    preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "unwindToSelectDailyPlan", sender: self);
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnSearchItem(_ sender: UITextField) {
        
        let search = sender.text!;
        
        if(search.length() > 0){
                characters = characters?.filter({ ($0.characterName?.lowercased().contains(search.lowercased()))! })
        }else{
            characters =  GlobalData.sharedInstance.myDailyPlan?.characters;
        }
        
        
        
        dump(characters)
           tableView.reloadData()
        
        
        
    }
    
    @IBAction func OnCancelButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToSelectArrivalWithSegue", sender: self)
    }
    
    @IBAction func unwindToListCharacter(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
