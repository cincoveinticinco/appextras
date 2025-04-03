//
//  GlobalData.swift
//  CardScanner
//
//  Created by Frontend on 19/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import Foundation
import Photos
import SwiftyJSON
import Validator


struct validationError: ValidationError {

    let message: String
    
    public init(_ message: String) {
        
        self.message = message
    }
}


class ListService {
    
    struct row{
        var id: Int
        var value:String
        var text: String
        var parent: Int = 0
    }
    
    var states: [row]!
    var agencies: [row]!
    var ranges: [row]!
    
}



class GlobalData{
    
    var unit: String!;
    var date: String?;
    var unit_number: String!;
    var talent: Talent?;
    var saveArrival: Int?;
    var photoCard:  [PHAsset]?;
    var countAlerts: Int = 0;
    var person: Person?;
    var myDailyPlan: DailyPlan?;
    var character: Characters?;
    var characterId: Int?;
    var dailyPlan: Int?;
    var serverURL: String = "";
    static var token: String?;
    static var logOut: Bool = false;
    var rolId: Int?;
    var productionId: Int = 0;
    var passWord: String?;
    var arrivalTime: String?;
    var _S3Controller: S3?;
    var characterHasId: Int = 0;
    var alertPersons: [Person] = [];
    var characterNamePrevius: String = "";
    var accessKey: String = "";
    var secretKey: String = "";
    var identityPool: String = "";
    var bucketName: String = "continuidadimg-min";
    var loginUser: Bool = false;
    var agencies: [row]?;
    var charatersSubmit: [Characters] = [];
    var incorrectPinCounter: Int = 0;
    var releaseString = "";
    
    
    struct row{
        var id: String
        var value:String
        var text: String
        var parent: Int
    }
    
    
    class ListService {
        var states: [row]!
        var agencies: [row]!
        var ranges: [row]!
        
        init(){
            self.states = [];
            self.agencies = [];
            self.ranges = [];
        }
    }
    
    struct Static {
        static var instance: GlobalData?
    }
    
    class var sharedInstance: GlobalData{
        
        if Static.instance == nil{
            Static.instance = GlobalData()
            Static.instance?.loginUser = false;
        }
        
        return Static.instance!
    }
    
    init(){
        
        SettingsBundleHelper.checkAndExecuteSettings();
        if (UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.server_url) != nil) {
            self.serverURL = UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.server_url)!;
        }else{
            self.serverURL = "https://ssostage.acciontv.com/";
        }
        
        if (UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.production_id) != nil) {
            self.productionId = Int(UserDefaults.standard.string(forKey: SettingsBundleHelper.SettingsBundleKeys.production_id)!)!
        }
        
        print("BUCKET NAME ENV: \(self.getEnvironment())")
        let bucketName = self.getEnvironment() == "Production" ? self.bucketName: "\(self.getEnvironment().lowercased())-\(self.bucketName)"
        print("BUCKET NAME: \(bucketName)")
        
       self._S3Controller = S3(
            accessKey: self.accessKey,
            secretKey: self.secretKey,
            identityPool: self.identityPool,
            bucketName: bucketName
        );
        
        
        
        
        
    }
    
    func dispose(){
        GlobalData.Static.instance = nil;
        GlobalData.token = nil
    }
    
    func getEnvironment() -> String{
        print("Server URL: \(self.serverURL)")
        if(self.serverURL.contains("testing")){
            return "Testing"
        }else if(self.serverURL.contains("staging")){
            return "Staging"
        }else{
            return "Production"
        }
    }
    
    func getTalentData(onSuccess: @escaping(ListService) -> Void, onFailure: @escaping(Error) -> Void){
        
        let params: NSMutableDictionary = [
            "production_id": GlobalData.sharedInstance.productionId,
            "date": GlobalData.sharedInstance.date!,
            "unit_id": GlobalData.sharedInstance.unit,
            ];
        
        
        ServiceManager
            .sharedInstance
            .sendRequest(route: "/casting/assign_talent_data", params: params,
                         onSuccess:{
                                json in
                                DispatchQueue.main.async {
                                    let listS = ListService();
                                    
                                    
                                    
                                    for item in json["managers"].arrayValue{
                                        listS.agencies.append(row(
                                                id: item["id"].stringValue,
                                                value: item["name"].stringValue,
                                                text: item["name"].stringValue,
                                                parent: 0));
                                    }
                                    
                                    listS.ranges.append(row(
                                        id: "0",
                                        value: "",
                                        text: "SELECT",
                                        parent: 0))
                                    for item in json["ages"].arrayValue{
                                        listS.ranges.append(row(
                                            id: item["id"].stringValue,
                                            value: item["range_name"].stringValue,
                                            text: item["range_name"].stringValue,
                                            parent: 0));
                                    }
                                    
                                    for item in json["states"].arrayValue{
                                        listS.states.append(row(
                                            id: item["id"].stringValue,
                                            value: item["name"].stringValue,
                                            text: item["abbreviation"].stringValue,
                                            parent: item["country_id"].intValue
                                            ));
                                        
                                    }
                                    
                                    let _row: row = row(id: "1", value: "", text:"",parent: 0);
                                    listS.agencies.append(_row)
                                    onSuccess(listS);
                                }
                        },
                        onFailure: {
                            error in
                                onFailure(error)
                            
            })
    }
    
    static func DateToString(date: Date, format: String = "yyyy-MM-dd", changeTimezone: Bool = false) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = format
        
        if changeTimezone{
            dateFormatter.timeZone = TimeZone(identifier: "GMT-5:00")
        }
        
        let stringDate = dateFormatter.string(from: date)
        
        
        
        
        return stringDate;
    }
    
    static func CreateDate(stringDate: String, format: String = "yyyy-MM-dd") -> Date{
        
       
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: stringDate) else {
            preconditionFailure("Take a look to your format")
        }
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
         
        
        return date
    }
}

extension Date{
    func getDateFor(years: Int) -> Date?{
        return Calendar.current.date(byAdding: .year, value: years, to: Date())
    }
}


