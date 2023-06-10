//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import Foundation

extension CoreDataSchemaRelationPairElement:CoreDataProperty{
    public var setSelectItemByType: SelectItem.SetSelectItemByType {
        return .coreDataSchemaRelationPairElement(self)
    }
    
    public static var entityName : String{
        return "CoreDataSchemaRelationPairElement"
        //why Self.entity().name possibliy be nil
    }
//    public static var mutableSetValueKey: String{
//        return "instances"
//    }
}
public extension CoreDataSchemaRelationPairElement{
    func getPairedElement()->CoreDataSchemaRelationPairElement{
        return self.pair!.elements!.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}).first {
            $0 != self
        }!
    }
    //CoreDataInstanceRelationPairElement
    var coreDataInstanceRelationPairElements: [CoreDataInstanceRelationPairElement]?{
        return instances?.allObjects.map({$0 as! CoreDataInstanceRelationPairElement})
    }
}
