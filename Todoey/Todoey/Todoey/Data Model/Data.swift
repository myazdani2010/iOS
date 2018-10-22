//
//  Data.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/22/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // dynamic is the declaration modifier. This tells to run dynamic dispatch over static dispatch and required by Realm
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
