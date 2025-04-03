//
//  ErrorCharacterViewController.swift
//  CardScanner
//
//  Created by Pablo A Aguero m on 22/11/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class ErrorCharacterViewController: UIViewController {
    
    @IBOutlet weak var viewError: UIView!
    var activityView: UIActivityIndicatorView?
    var text: UILabel?;

    @IBOutlet weak var alertLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewError.isHidden = true;
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        
        text = UILabel(frame: CGRect(x: 60, y: 0, width: 70, height: 50))
        text?.center.x = self.view.center.x;
        text?.center.y = self.view.center.y + 30;
        text?.textColor = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        text?.textAlignment = .center;
        text?.text = "Loading"
        self.view.addSubview(text!)
        
        self.view.addSubview(activityView!)
        
        self.activityView?.startAnimating();
        
        
        let person = GlobalData.sharedInstance.person;
        
        person?.validateCharacter(onSuccess:
            {
                json in
                DispatchQueue.main.async {
                    print(json)
                    self.activityView?.hidesWhenStopped = true;
                    self.activityView?.stopAnimating();
                    self.text?.isHidden = true;
                    
                    let error = json["error"].intValue;
                    
                    //Utils.showMessage("CONN_STATES.CONNECTED", message: "\(json)")
                    
                    switch error {
                        case 0:
                            print("SI firma release")
                            GlobalData
                                .sharedInstance.characterHasId = 0;
                            self.performSegue(withIdentifier: "agreementSegue", sender: self)
                            //Firma release
                            break;
                        case 1:
                            self.alertLabel.text = json["msg"].stringValue;
                            self.viewError.isHidden = false;
                            break;
                        case 2:
                            print("No firma release / sin aprobar")
                            GlobalData.sharedInstance.characterHasId = 1;
                            GlobalData.sharedInstance.person?.isApproved = true;
                            GlobalData.sharedInstance.person?.isStored = true;
                            self.performSegue(withIdentifier: "agreementSegue", sender: self)
                            
                            break;
                        case 3:
                            print("No firma release")
                            GlobalData.sharedInstance.characterHasId = 1;
                            GlobalData.sharedInstance.person?.isStored = true;
                            self.performSegue(withIdentifier: "agreementSegue", sender: self)
                            break;
                        
                        default:
                            print("rojo")
                        
                    }
                    
                }
        }, onFailure: {
            error in
                self.alertLabel.text = error.localizedDescription
        })
        
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func OnSelectAnotherCharacter(_ sender: Any) {
        performSegue(withIdentifier: "unwindToListCharacterSegue", sender: self)
    }
    @IBAction func OnCancelCharacter(_ sender: Any) {
        performSegue(withIdentifier: "unwindToSelectArrivalWithSegue", sender: self)
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
