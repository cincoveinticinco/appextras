//
//  CharacterData.swift
//  CardScanner
//
//  Created by 525 on 5/12/17.
//  Copyright © 2017 525. All rights reserved.
//

import Foundation
import SQLite

// Character Data: firstname, lastname, id, dob, expirationdate,

class CharacterData {
    let path: String
    let db: Connection?
    
    let characters = Table("characters")
    let people = Table("people")
    let photos = Table("photos")
    
    let id = SQLite.Expression<Int64>("id")
    let serverId = SQLite.Expression<Int64>("id_server")
    let characterFirstName = SQLite.Expression<String?>("first_name")
    let characterLastName = SQLite.Expression<String?>("last_name")
    let characterAddress = SQLite.Expression<String?>("address")
    let characterCity = SQLite.Expression<String?>("city")
    let locationPostalCode = SQLite.Expression<String?>("postal_code")
    let locationRequest = SQLite.Expression<Data>("request")
    
    let productionTableId = SQLite.Expression<Int64>("id")
    let productionId = SQLite.Expression<Int>("id_production")
    let productionLocationId = SQLite.Expression<Int>("id_location")
    let productionScriptName = SQLite.Expression<String?>("script_name")
    
    let photoId = SQLite.Expression<Int64>("id")
    let photoUrl = SQLite.Expression<String?>("url")
    let photoLocationId = SQLite.Expression<Int64>("id_location")
    
    static let data = CharacterData()
    
    init() {
        self.path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            self.db = try Connection("\(path)/scannerDB.sqlite3")
            createTables()
        } catch {
            self.db = nil
            print (error)
        }
    }
    
    
    
    
    func createTables() {
        do {
            try db?.run(characters.create(ifNotExists: true) { loc in
                print(".... Creating TABLE Characters")
                loc.column(id, primaryKey: .autoincrement)
                loc.column(serverId, unique: false, defaultValue: nil)
                loc.column(characterFirstName, unique: true)
                loc.column(characterAddress, unique: true)
                loc.column(characterCity)
                loc.column(locationPostalCode)
                loc.column(locationRequest)
            })
            try db?.run(people.create(ifNotExists: true) { prod in
                print(".... Creating TABLE People")
                prod.column(productionTableId, primaryKey: .autoincrement)
                prod.column(productionId, unique: false)
                prod.column(productionLocationId, unique: true)
                prod.column(productionScriptName, unique: true)
            })
            try db?.run(photos.create(ifNotExists: true) { photo in
                print(".... Creating TABLE Photos")
                photo.column(photoId, primaryKey: .autoincrement)
                photo.column(photoLocationId, unique: false)
                photo.column(photoUrl, unique: false)
            })
        } catch {
            print(error)
        }
    }
    
    func addCharacter(name: String, address: String, city: String, postalCode: String, req: Data) -> Int64? {
        do {
            let insert = characters.insert(serverId <- 0,
                                          characterFirstName <- name,
                                          characterAddress <- address,
                                          characterCity <- city,
                                          locationPostalCode <- postalCode,
                                          locationRequest <- req)
            let rowid = try db!.run(insert)
            
            return rowid
        } catch {
            print(error)
            return nil
        }
    }
}
