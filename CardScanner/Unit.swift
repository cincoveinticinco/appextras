//
//  Unit.swift
//  CardScanner
//
//  Created by Frontend on 24/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import Foundation

class Unit: Codable {
    var id:Int?
    var unit_number: String?
    var start_date: Date?
    var end_date: Date?

    
    init(id: Int, unit_number: String?, start_date:String, end_date: String) {
        self.id = id;
        self.unit_number = unit_number;
        self.start_date = GlobalData.CreateDate(stringDate: start_date) ;
        self.end_date = GlobalData.CreateDate(stringDate: end_date);
    }
    
    static func getUnit(onSuccess: @escaping(NSMutableDictionary) -> Void, onFailure: @escaping(String) -> Void) -> Void{
        var units = Array<Unit>();
        var agencies = Array<GlobalData.row>();
        let params: NSMutableDictionary = ["production_id": GlobalData.sharedInstance.productionId];
        
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/getUnits/", params: params, onSuccess:
            {
                json in
                DispatchQueue.main.sync {
                    if(json["error"].bool == false){
                        for item in json["units"].arrayValue{
                            units.append(Unit(
                                    id: item["id"].intValue,
                                    unit_number: item["unit_number"].stringValue,
                                    start_date: item["start_date"].stringValue,
                                    end_date: item["end_date"].stringValue)
                            )
                        }
                        
                        agencies.append(GlobalData.row(
                            id: "",
                            value: "",
                            text: "",
                            parent: 0))
                        
                        for item in json["agencies"].arrayValue{
                            agencies.append(GlobalData.row(
                                id: item["id"].stringValue,
                                value: item["name_agency"].stringValue,
                                text: item["name_agency"].stringValue,
                                parent: 0));
                        }
                        
                        onSuccess([
                            "units":units,
                            "start_date": json["start_date"].stringValue,
                            "end_date": json["end_date"].stringValue,
                            "agencies": agencies
                        ]);
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
