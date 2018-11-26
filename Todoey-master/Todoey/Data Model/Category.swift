//
//  Category.swift
//  Todoey
//
//  Created by 小海 on 12/05/2018.
//  Copyright © 2018 Xiaohai Sun. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()

}
