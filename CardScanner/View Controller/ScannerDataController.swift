//
//  ScannerDataController.swift
//  CardScanner
//
//  Created by 525 on 7/12/17.
//  Copyright © 2017 525. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

// MARK: - Data Handling
extension ScannerViewController {
    
    func saveDataFromJSON(json: JSON) {
        
        let characters = json[DataKey.Productions].arrayValue.map {$0.dictionaryObject!}
        for character in characters {
            let char = Characters()
            
            char.id = character[DataKey.ID] as? Int
            char.characterName = character[DataKey.ValidName] as? String
            
            self.characters.append(char)
            DispatchQueue.main.async {
                
            }
        }
        
        let agencies = json[DataKey.Productions].arrayValue.map {$0.dictionaryObject!}
        for agency in agencies {
            let agen = Characters()
            
            agen.id = agency[DataKey.ID] as? Int
            agen.characterName = agency[DataKey.ValidName] as? String
            
            self.characters.append(agen)
            DispatchQueue.main.async {
                
            }
        }
        
    }
    
}

// MARK: - Keys

extension UIViewController {
    struct DataKey {
        static let Server = GlobalData.sharedInstance.serverURL;
        static let ImageServer = "https://s3.amazonaws.com/continuidadimg-min/"
        static let ImageThumbs = "thumbnails/"
        static let Productions = "productions"
        static let SecureModules = "secure_modules"
        static let ProductionRoles = "production_rols"
        static let ID = ""
        static let ValidName = ""
    }
}
