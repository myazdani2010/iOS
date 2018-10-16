//
//  Item.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/16/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import Foundation

//Codable is equal to Encodable and Decodable
class Item : Codable {
    
    var title : String = ""
    var done : Bool = false
}
