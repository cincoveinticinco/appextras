//
//  Person.swift
//  CardScanner
//
//  Created by 525 on 1/12/17.
//  Copyright © 2017 525. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PersonError: Error {
    case nullPerson
}

extension PersonError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .nullPerson:
            return NSLocalizedString("Person is Null", comment: "Invalid Person")
        }
    }
}

class Person {
    var id: String?
    var name: String?
    var middleName:String?
    var lastName: String?
    var age: Int?
    var age_range: String?
    var gender: String?
    var address: String?
    var unit: String?
    var country: String?
    var city: String?
    var state: String?
    var stateString: String?;
    var zip: String?
    var birthday: Date?
    var expirationDate: String?
    var postalCode:String?
    var artisticName: String?
    var countryCode: String?
    var phone: String?
    var email: String?
    var agency: String?
    var guardian: Person?
    var imageCard: String?
    var imageSignature: String?
    var dailyPlan: Int?
    var characterHasId: Int?
    var characterId: Int?
    var isMenor: Bool?
    var isStored: Bool = false;
    var isApproved: Bool = false;
    
    init(id: String, name: String, middleName: String, lastName: String, address: String, city: String, state: String, zip: String, birthday: String, expirationDate: String, gender: String) {
        
        self.id = id
        self.name = name
        self.middleName = middleName
        self.lastName = lastName
        self.age = 30
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        if birthday.count == 8 {
            let year = birthday.substringWithRange(4..<8)
            let day = birthday.substringWithRange(2..<4)
            let month = birthday.substringToIndex(2)
            
            
            self.birthday = dateFormatter.date(from: year+"-"+month+"-"+day+" 09:00:00")!
        }
        
        
        
        
        self.expirationDate = expirationDate
        self.gender = gender
    }
    
    init() {
        //self.birthday = Date();
    }
    
    func toString() -> String{
        return self.name!;
    }
    
    func saveTime(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) -> Void{
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        GlobalData.sharedInstance.arrivalTime = "\(hour):\(minutes):\(seconds)";
        
        let params : NSMutableDictionary = [
            "daily_plan_id": self.dailyPlan!,
            "character_has_talent_id": self.characterHasId!,
            "character_id": self.characterId!,
            "arrived_time": GlobalData.sharedInstance.arrivalTime!
        ];
        
        print(params)
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/save_time/", params: params, onSuccess: {
            json in
            DispatchQueue.main.async {
                print("JSON")
                onSuccess(json)
            }
        }, onFailure: {
            error in
            onFailure(error)
            
        })
    }
    
    func validateCharacter(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) -> Void{
        let params : NSMutableDictionary = [
            "id_production": GlobalData.sharedInstance.productionId,
            "name_talent": self.name!,
            "last_name_talent": self.lastName!,
            "date_birth_talent": GlobalData.DateToString(date: self.birthday!),
            "character_id": self.characterId!,
            "date": GlobalData.sharedInstance.date!,
        ];
        
        print(String(describing: params));
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/validate_character/", params: params,
                        onSuccess:{
                            json in
                                DispatchQueue.main.async {
                                    onSuccess(json);
                                }
                        } , onFailure: {
                            error in
                                onFailure(error)
                                print(error)
                        }
                )
    }
    
    
    
    func storedPerson(isApprove: Bool = false, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) -> Void{
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        
        GlobalData.sharedInstance.arrivalTime = "\(hour):\(minutes)";
        
        let params : NSMutableDictionary = [
            "agency": self.agency!,
            "name_talent": self.name!,
            "middle_name_talent": self.middleName!,
            "last_name_talent": self.lastName!,
            "artistic_name": self.artisticName!,
            "date_birth_talent": GlobalData.DateToString(date: self.birthday!),
            "ages_range_id": self.age_range!,
            "gender_talent": self.gender!,
            "country_code": 1,
            "phone_talent": self.phone!,
            "email": self.email!,
            "address_talent": self.address!,
            "unit_address_talent": self.unit!,
            "county_address_talent": self.country!,
            "city_address_talent": self.city!,
            "state_address_talent": self.state!,
            "postalcode_address_talent": self.postalCode!,
            "name_guardian_talent": self.guardian!.name!,
            "middle_name_guardian_talent": self.guardian!.middleName!,
            "last_name_guardian_talent": self.guardian!.lastName!,
            "country_code_guardian_talent": 1,
            "phone_guardian_talent": self.guardian!.phone!,
            "email_guardian_talent": self.guardian!.email!,
            "address_guardian_talent": self.guardian!.address!,
            "unit_guardian_talent": self.guardian!.unit!,
            "county_address_guardian_talent": self.guardian!.country!,
            "city_address_guardian_talent": self.guardian!.city!,
            "state_address_guardian_talent": self.guardian!.state!,
            "postalcode_address_guardian_talent": self.guardian!.postalCode!,
            "imagen": self.imageCard ?? "",
            "signature": self.imageSignature ?? "",
            "date": GlobalData.DateToString(date: Date()),
            "daily_plan_id": GlobalData.sharedInstance.dailyPlan!,
            "character_has_talent_id": self.characterHasId ?? "",
            "character_id": self.characterId!,
            "arrived_time":GlobalData.sharedInstance.arrivalTime!

            
        ];
        
        if isApprove {
            params["approved"] = 1;
        }
        
        print(String(describing: params));
        
        
        ServiceManager.sharedInstance.sendRequest(route: "/app_release/assignment/", params: params,
            onSuccess:
            {
                json in
                DispatchQueue.main.async {
                    onSuccess(json);
                    
                }
            },
            
            onFailure: {
                error in
                    onFailure(error)
                    print(error)
            })
    }
    
    func getInfoTalent(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) -> Void{
        
        
        
        if(self.name == nil){
            let error: PersonError = PersonError.nullPerson;
            onFailure(error);
        }else{
            let params : NSMutableDictionary = [
                "name_talent": self.name!,
                "last_name_talent": self.lastName!,
                "date_birth_talent": GlobalData.DateToString(date: self.birthday!),
            ];
            
               print("entro aqui Search talent")
            
            ServiceManager.sharedInstance.sendRequest(route: "/app_release/get_info_actor/", params: params,
                  onSuccess:{
                    json in
                    DispatchQueue.main.async {
                        print("on request")
                        print(json)
                        onSuccess(json);
                    }
            } , onFailure: {
                error in
                onFailure(error)
                print(error)
            })
        }
        
        
    }
        
    
}
