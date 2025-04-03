//
//  SettingsBundleHelper.swift
//  CardScanner
//
//  Created by Frontend on 8/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let server_url = "server_url"
        static let production_id = "production_id"
    }
    
    
    class func checkAndExecuteSettings() {
        
        if (UserDefaults.standard.string(forKey: SettingsBundleKeys.server_url) == nil) {
            UserDefaults.standard.set("https://prod.acciontv.com/api/", forKey: SettingsBundleKeys.server_url)
        }
        
        if (UserDefaults.standard.string(forKey: SettingsBundleKeys.production_id) == nil) {
            UserDefaults.standard.set("133", forKey: SettingsBundleKeys.production_id)
        }
        
        
        
        //let appDomain: String? = Bundle.main.bundleIdentifier
        //UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(build, forKey: "build_preference")
    }
}
