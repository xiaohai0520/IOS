//
//  Item.swift
//  Todoey
//
//  Created by 小海 on 12/05/2018.
//  Copyright © 2018 Xiaohai Sun. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
