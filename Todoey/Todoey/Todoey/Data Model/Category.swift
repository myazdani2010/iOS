//
//  Category.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/22/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    //forward relationship
    let items = List<Item>()
    @objc dynamic var backgroundColor: String = ""
}
