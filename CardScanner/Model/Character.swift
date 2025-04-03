//
//  Character.swift
//  CardScanner
//
//  Created by 525 on 7/12/17.
//  Copyright © 2017 525. All rights reserved.
//

import Foundation

class Characters {
    var id: Int?
    var dailyPlanId: Int?
    var characterName: String?
    var characterHasId: Int?
    var characterRol: Int?
    var characterCallSheet: Int?
    var talent: [Talent]?;
    
    init(){}
    
    init(id: Int, dailyPlanId: Int,characterName: String, characterRol: Int, characterHasId: Int, characterCallSheet: Int? = 0, talent: [Talent]){
        self.id = id;
        self.dailyPlanId = dailyPlanId;
        self.characterName = characterName;
        self.characterRol = characterRol;
        self.characterHasId =  characterHasId;
        self.characterCallSheet =  characterCallSheet;
        self.talent = talent;
        
    }
    
    
    static func saveInfoExtra(character: Characters, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(String) -> Void) -> Void{
        
         let params: NSMutableDictionary = [
            "character_id": character.id!,
            "character_has_talent_id": character.characterHasId!,
            "call_sheet_character_id": character.characterCallSheet!,
            "observation": character.talent?[0].notes ?? "",
            "ot": character.talent?[0].ot ?? false,
            "type_id": character.talent?[0].check_status ?? "",
            
        ];
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/save_info_extra/", params: params, onSuccess:
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
