//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import Foundation

extension CoreDataInstanceRelationPairElement:CoreDataProperty{
    public var setSelectItemByType: SelectItem.SetSelectItemByType {
        return .coreDataInstanceRelationPairElement(self)
    }
    
    public static var entityName : String{
        return "CoreDataInstanceRelationPairElement"
        //why Self.entity().name possibliy be nil
    }
//    public static var mutableSetValueKey: String{
//        return ""
//    }
}
public extension CoreDataInstanceRelationPairElement{
    func getPairedElement()->CoreDataInstanceRelationPairElement{
        return self.pair!.elements!.allObjects.map({$0 as! CoreDataInstanceRelationPairElement}).first {
            $0 != self
        }!
    }
}
