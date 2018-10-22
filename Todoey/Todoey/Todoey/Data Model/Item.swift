//
//  Item.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/22/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //backward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
