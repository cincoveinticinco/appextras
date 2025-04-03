//
//  ListRolViewController.swift
//  CardScanner
//
//  Created by Frontend on 13/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit

class ListRolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellButtonTableViewCell", for: indexPath) as! CellButtonTableViewCell
        
        cell.labelCell?.text = roles![indexPath.item].rolName?.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalData.sharedInstance.rolId = roles![indexPath.item].idRol;
        self.performSegue(withIdentifier: "ChoseCharacterSegue", sender: self);
    }
    
    let myarray = ["item1", "item2", "item3"]
    let roles: [Rol]? = [Rol(idRol: 7, rolName: "Extra")] //GlobalData.sharedInstance.myDailyPlan?.rols;
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        tableView.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalData.sharedInstance.rolId = roles![0].idRol;
        self.performSegue(withIdentifier: "ChoseCharacterSegue", sender: self);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnCancelButton(_ sender: Any) {
        GlobalData.sharedInstance.saveArrival = 0;
        performSegue(withIdentifier: "unwindToSelectArrival", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     @IBAction func unwindToListRol(segue:UIStoryboardSegue) { }

}
