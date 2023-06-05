//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import Foundation


public protocol CoreDataProperty{
    static var entityName : String {get}
    var setSelectItemByType: SelectItem.SetSelectItemByType{get}
    //static var mutableSetValueKey : String{get}
}
