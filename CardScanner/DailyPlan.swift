//
//  DailyPlan.swift
//  CardScanner
//
//  Created by Frontend on 25/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import Foundation
import SwiftyJSON

class DailyPlan{
    
    var characters: [Characters]!;
    var rols: [Rol]!;
    var talents: [Talent];
    var productionName: String?
    var endDate: Date?
    
    init(characters: [Characters], rols: [Rol], productionName: String, endDate: String, talents: [Talent]) {
        self.characters = characters;
        self.rols = rols;
        self.productionName = productionName;
        self.endDate = GlobalData.CreateDate(stringDate: endDate);
        self.talents = talents;
    }
    
   
    static func getDailyPlan(onSuccess: @escaping (DailyPlan) -> Void, onFailure: @escaping(String) -> Void) -> Void{
        
        let params: NSMutableDictionary = [
            "production_id": GlobalData.sharedInstance.productionId,
            "date": GlobalData.sharedInstance.date!,
            "unit_id": GlobalData.sharedInstance.unit,
        ];
        
        print(params)
        
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/getDailyPlan/", params: params, onSuccess:{
            json in
            DispatchQueue.main.async {
                
                var chars: [Characters] = [];
                var rols: [Rol] = [];
                var actors: [Talent] = [];
                
                if(json["error"].bool == false){
                    for character in json["characters"].arrayValue{
                        var talents:[Talent] = [];
                        for talent in character["talent"].arrayValue{
                            var dateOfBrith: Date?;
                            
                            if talent["date_of_birth"] != JSON.null {
                                dateOfBrith = GlobalData.CreateDate(stringDate: talent["date_of_birth"].stringValue)
                            }
                            
                            talents.append(Talent(
                                name: talent["name"].stringValue,
                                middle_name: talent["middle_name"].stringValue,
                                last_name: talent["last_name"].stringValue,
                                characterHasTalentId: talent["character_has_talent_id"].intValue,
                                date_of_birth: dateOfBrith
                            ))
                        }
                        
                        print(character["character_rol_id"].intValue)
                        if(character["character_rol_id"].intValue == 7){
                            chars.append(Characters(
                                id: character["id"].intValue,
                                dailyPlanId : character["daily_plan_id"].intValue,
                                characterName : character["character_name"].stringValue,
                                characterRol : character["character_rol_id"].intValue,
                                characterHasId: character["character_has_talent_id"].intValue,
                                talent: talents
                            ))
                        }
                        
                    }
                    
                    for rol in json["rols"].arrayValue{
                        rols.append(Rol(
                            idRol: rol["id"].intValue,
                            rolName: rol["character_rol_name"].stringValue
                        ))
                        
                    }
                    
                    for act in json["actors"].arrayValue{
                        print(act["date_of_birth"].stringValue)
                        
                        if act["date_of_birth"].stringValue != ""{
                            let actor = Talent(name: act["name"].stringValue, last_name: act["last_name"].stringValue, date_of_birth: GlobalData.CreateDate(stringDate: act["date_of_birth"].stringValue))
                            
                            actors.append(actor)
                        }
                        
                        
                    }
                    
                    if(chars.count > 0){
                        print(json)
                        
                        GlobalData.sharedInstance.dailyPlan = chars[0].dailyPlanId;
                        onSuccess(DailyPlan(characters: chars, rols: rols, productionName: json["production_name"].stringValue, endDate: json["production_end_date"].stringValue, talents:actors))
                    }else{
                        onFailure("This daily plan doesn’t have extras assigned")
                    }
                    
                }else{
                    print("error")
                    print(String(describing: json.dictionary))
                    print(json["msg"].stringValue)
                    onFailure(json["msg"].stringValue)
                }
            }
            
        }, onFailure: {
            error in
            print(error.localizedDescription)
            onFailure(error.localizedDescription)
        })
    }
    
    
    static func getCharactesPlan(onSuccess: @escaping ([Characters]) -> Void, onFailure: @escaping(String) -> Void) -> Void{
        
//        print(GlobalData.sharedInstance.dailyPlan!)
        
        let params: NSMutableDictionary = [
            "plan_id": GlobalData.sharedInstance.dailyPlan!,
        ];
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/characters_plan/", params: params, onSuccess:{
            json in
            DispatchQueue.main.async {
                
                var chars: [Characters] = [];
                
                if(json["error"].bool == false){
                    
                    print(json)
                    
                    var char_talent:Talent? = nil;
                    
                    for character in json["characters"].arrayValue{
                        
                        var dateOfBrith: Date?;
                        
                        if character["date_of_birth"] != JSON.null {
                            dateOfBrith = GlobalData.CreateDate(stringDate: character["date_of_birth"].stringValue)
                        }
                        
                        char_talent = Talent(
                            name: character["full_name"].stringValue,
                            middle_name: "",
                            last_name: "",
                            characterHasTalentId: character["character_has_talent_id"].intValue,
                            date_of_birth: dateOfBrith,
                            phone:  character["phone"].stringValue,
                            email:  character["email"].stringValue,
                            agency:  character["name_agency"].stringValue,
                            scenas_player:  character["scenes_characters"].stringValue,
                            check_time: character["arrived_time"].stringValue
                            
                            
                            
                            
                        )
                        
                        char_talent?.ot = character["ot"].boolValue
                        char_talent?.notes = character["observation"].stringValue
                        char_talent?.check_status = character["type_id"].stringValue
                        char_talent?.check_time_label = character["type_name"].stringValue
                        char_talent?.characters_actor = character["characters_actor"].stringValue
                        
                        print(character["character_name"].stringValue)
                        print(character["characters_actor"].stringValue)
                        
                        
                        chars.append(Characters(
                            id: character["id"].intValue,
                            dailyPlanId : character["daily_plan_id"].intValue,
                            characterName : character["character_name"].stringValue,
                            characterRol : character["character_rol_id"].intValue,
                            characterHasId: character["character_has_talent_id"].intValue,
                            characterCallSheet: character["call_sheet_character_id"].intValue,
                            talent: [(char_talent ?? nil)!]
                        ))
                        
                        
                    }
                    
                    if(chars.count > 0){
                        print(json)
                        
                        chars = chars.sorted(by: { $0.talent![0].name!.lowercased().localizedCaseInsensitiveCompare($1.talent![0].name!.lowercased()) == ComparisonResult.orderedAscending })
                        onSuccess(chars)
                    }else{
                        onFailure("This daily plan doesn’t have extras assigned")
                    }
                    
                }else{
                    onFailure(json["msg"].stringValue)
                }
            }
            
        }, onFailure: {
            error in
            print(error.localizedDescription)
            onFailure(error.localizedDescription)
        })
    }
    
    
    static func submitExtras(observation: String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(String) -> Void) -> Void{
        
        let params: NSMutableDictionary = [
            "plan_id": GlobalData.sharedInstance.dailyPlan!,
            "comment" : observation
        ];
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/submit_extra/", params: params, onSuccess:
            {
                json in
                DispatchQueue.main.sync {
                    if(json["error"].bool == false){
                        onSuccess(true)
                    }else{
                        onFailure(json["msg"].stringValue)
                    }
                }
                
        }, onFailure: {
            error in
            print(error.localizedDescription);
            onFailure(error.localizedDescription)
        }
        )
        
    }
}
