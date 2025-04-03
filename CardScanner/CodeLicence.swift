//
//  CodeLicence.swift
//  CardScanner
//
//  Created by Pablo A Aguero m on 7/11/18.
//  Copyright © 2018 525. All rights reserved.
//

import Foundation



enum ParceLicenceError: Error {
    case NoIndexError
    case InvalidBirthDayDate
}

class ParseLicence{
    
    var CodeKey: [String: String] = [
        "DCA" : "jurisdictionVehicleClass",
        "DCB" : "jurisdictionRestrictionCodes",
        "DCD" : "jurisdictionEndorsementCodes",
        "DBA" : "dateOfExpiry",
        "DCS" : "lastName",
        "DAA" : "fullName",
        "DAC" : "firstName",
        "DAD" : "middleName",
        "DBD" : "dateOfIssue",
        "DBB" : "dateOfBirth",
        "DBC" : "sex",
        "DAY" : "eyeColor",
        "DAU" : "height",
        "DAG" : "addressStreet",
        "DAI" : "addressCity",
        "DAJ" : "addressState",
        "DAK" : "addressPostalCode",
        "DAQ" : "documentNumber",
        "DCF" : "documentDiscriminator",
        "DCG" : "issuer",
        "DDE" : "lastNameTruncated",
        "DDF" : "firstNameTruncated",
        "DDG" : "middleNameTruncated",
        // optional
        "DAZ" : "hairColor",
        "DAH" : "addressStreet2",
        "DCI" : "placeOfBirth",
        "DCJ" : "auditInformation",
        "DCK" : "inventoryControlNumber",
        "DBN" : "otherLastName",
        "DBG" : "otherFirstName",
        "DBS" : "otherSuffixName",
        "DCU" : "nameSuffix", // e.g. jr, s,
        "DCE" : "weightRange",
        "DCL" : "race",
        "DCM" : "standardVehicleClassification",
        "DCN" : "standardEndorsementCode",
        "DCO" : "standardRestrictionCode",
        "DCP" : "jurisdictionVehicleClassificationDescription",
        "DCQ" : "jurisdictionEndorsementCodeDescription",
        "DCR" : "jurisdictionRestrictionCodeDescription",
        "DDA" : "complianceType",
        "DDB" : "dateCardRevised",
        "DDC" : "dateOfExpiryHazmatEndorsement",
        "DDD" : "limitedDurationDocumentIndicator",
        "DAW" : "weightLb",
        "DAX" : "weightKg",
        "DDH" : "dateAge18",
        "DDI" : "dateAge19",
        "DDJ" : "dateAge21",
        "DDK" : "organDonor",
        "DDL" : "veteran",
        ]
    
    func parse(str: String) throws -> [String: String]{
        
        let dir_data = self.__parse(str: str);
        let index_required = ["firstName","lastName","addressStreet","addressCity","addressState","addressPostalCode"]
        
        for index in index_required{
            
            if dir_data[index] == nil{
                print("Error:" + index)
                throw ParceLicenceError.NoIndexError;
            }
            
           
        }
        
        return dir_data;
    }
    
    func parse_magnetic(track1: String?, track2: String?, track3: String?) throws  ->[String: String]{
        
        let dir_data = self.__parse_magneitbar(track1: track1 ?? "", track2: track2 ?? "", track3: track3 ?? "")
        let index_required = ["firstName","lastName","addressStreet","addressCity","addressState","addressPostalCode"]
        
        
        for index in index_required{
            
            if dir_data[index] == nil{
                print("Error:" + index)
                throw ParceLicenceError.NoIndexError;
            }
            
            
        }
        
        return dir_data
        
     
    }
    
    private func __parse_magneitbar(track1: String, track2: String, track3: String) ->[String: String] {
        var dictionary:[String: String] = [:];
        
        
        do {
            //TRACK 1
            print(track1)
            print(track2)
            print(track3)
            
            if !track1.isEmpty {
                let split_track1 = track1.components(separatedBy: "^")
                print(split_track1)
                dictionary["addressState"] = split_track1[0][1..<3];
                dictionary["addressCity"] = split_track1[0][3..<split_track1[0].count];
                dictionary["addressStreet"] = split_track1[2];
                
                let split_name = split_track1[1].components(separatedBy: "$")
                let split_middle = split_name.indices.contains(1) ? split_name[1].components(separatedBy: " ") : []
                
                if split_middle.count > 1 {
                    dictionary["firstName"] = split_middle[0]
                    dictionary["middleName"] = split_middle[1]
                }else{
                    dictionary["firstName"] = split_name.indices.contains(1) ? split_name[1] : ""
                    dictionary["middleName"] = split_name.indices.contains(2) ? split_name[2] : ""
                }
                
                dictionary["lastName"] = split_name[0]
                
            }
            
            
            //TRACK 2
            print(track2)
            if !track2.isEmpty {
                dictionary["issuer"] = track2[1..<7]
                dictionary["documentNumber"] = track2[7..<20]
                dictionary["dateOfExpiry"] = track2[21..<25]
                print(track2[25..<33])
                dictionary["dateOfBirth"] = getBirthDay(value: track2[25..<33], older: true);
            }
            
            
            //TRACK 3
            if !track3.isEmpty {
                print("track 3")
                dictionary["addressPostalCode"] = track3[3..<9]
                dictionary["jurisdictionVehicleClass"] = track3[14..<16]
                dictionary["jurisdictionRestrictionCodes"] = track3[16..<26]
                dictionary["jurisdictionEndorsementCodes"] = track3[26..<30]
                dictionary["sex"] = getSex(value: track3[30..<31]);
                dictionary["height"] = track3[31..<34]
                dictionary["weightLb"] = track3[34..<37]
                dictionary["hairColor"] = track3[37..<40]
                dictionary["eyeColor"] = track3[40..<43]
                
            }
            
            
            print(dictionary)
            return dictionary;
        }catch {
            print("Error ")
        }
        
    }
    
    private func __parse(str: String) ->[String: String] {
        
        print(str)
        
        var dictionary:[String: String] = [:];
        let rawLines = str.components(separatedBy: "\n")
        let lines = rawLines;
        var started = false;
        var isOlder = false;
        
        
        lines.forEach { line in
            if(!started){
                if(line.range(of: "ANSI ") != nil){
                    
                    started = true
                    
                    if line.contains("DAA") {
                        if let index = line.range(of:"DAA")  {
                            
                            let start_position = line.distance(from: line.startIndex, to: index.upperBound)
                            let end_position = line.distance(from: line.startIndex, to: line.endIndex)
                            
                            let new_line = line[start_position..<end_position];
                            let arr_fullname = new_line.components(separatedBy: ",");
                            
                            if arr_fullname[0] != "" {
                                dictionary["lastName"] = arr_fullname[0].trimmingCharacters(in: .whitespacesAndNewlines);
                            }
                            
                            if arr_fullname[1] != ""{
                                dictionary["firstName"] = arr_fullname[1].trimmingCharacters(in: .whitespacesAndNewlines);
                            }
                            
                            if arr_fullname[2] != ""{
                                    dictionary["middleName"] = arr_fullname[2].trimmingCharacters(in: .whitespacesAndNewlines);
                            }
                            
                            
                        }
                        isOlder = true;
                        print("exists old")
                    }
                    
                    if line.contains("DAQ") {
                        if let index = line.range(of: "DAQ"){
                            
                            let start_position = line.distance(from: line.startIndex, to: index.upperBound)
                            let end_position = line.distance(from: line.startIndex, to: line.endIndex)
                            
                            let new_line = line[start_position..<end_position];
                            let value = getValue(line: new_line);
                            
                            dictionary["documentNumber"] = value
 
                        }
                        
                        print("exists new ")
                    }
                }
                return
            }
            
            let code = getCode(line: line);
            var value = getValue(line: line);
            let key = getKey(code: code);
            
            if(code == "DBC"){
                value = getSex(value: value);
            }
            
            if(code == "DBB"){
                value = getBirthDay(value: value, older: isOlder);
            }
            
            
            dictionary[key] = value.trimmingCharacters(in: .whitespacesAndNewlines);
        }
        
        print(dictionary)
        return dictionary;
    }
    
    func getCode(line: String) -> String{
        return line.substringWithRange(0..<3)
    }
    
    func getValue(line: String) -> String {
        return String(line.dropFirst(3))
    }
    
    func  getKey(code: String) -> String{
        if let key = self.CodeKey[code] {
            return key
        }
        return "nokey";
    }
    
    
    
    func getSex(value: String) -> String{
        return value == "1" ? "M" : "F";
    }
    
    func getBirthDay(value: String, older: Bool) -> String{
        
        
        
        if older {
            if Int(value.substringWithRange(4..<6)) ?? 99 >= 12{
                return "";
            }
            
            return "\(value.substringWithRange(4..<6))\(value.substringWithRange(6..<8))\(value.substringWithRange(0..<4))"
        }
        
        return value;
    }
    
    /*func sanitizeData(rawLine){
        rawl
    }*/
}
