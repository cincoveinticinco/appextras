//
//  Talent.swift
//  CardScanner
//
//  Created by Frontend on 19/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import Foundation

class Talent{
    var name: String?
    var middle_name: String?
    var last_name: String?
    var characterHasTalentId: Int?
    var date_of_birth: Date?
    var phone: String?
    var email: String?
    var agency: String?
    var scenas_player: String?
    var check_time: String?
    var ot: Bool?;
    var alerts: String?;
    var check_status: String?
    var check_time_label: String?;
    var notes: String?
    var characters_actor: String?
    
    init(name: String, last_name: String, date_of_birth: Date?){
        self.name = name;
        self.last_name = last_name;
        self.date_of_birth = date_of_birth;
    }
    
    init(name: String, middle_name: String, last_name: String, characterHasTalentId: Int, date_of_birth: Date?, phone: String = "", email: String = "", agency: String = "", scenas_player: String = "", check_time: String = ""){
        self.name = name;
        self.middle_name = middle_name;
        self.last_name = last_name;
        self.characterHasTalentId = characterHasTalentId;
        self.date_of_birth = date_of_birth;
        
        self.phone = phone;
        self.email = email;
        self.agency = agency;
        self.alerts = agency;
        self.scenas_player = scenas_player;
        self.check_time = check_time;
        
    }
    
 
}
