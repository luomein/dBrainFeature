//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import CoreData

extension CoreDataSchemaRelationPair:CoreDataProperty{
    public var setSelectItemByType: SelectItem.SetSelectItemByType {
        return .none
    }
    
    public static var entityName : String{
        return "CoreDataSchemaRelationPair"
        //why Self.entity().name possibliy be nil
    }
//    public static var mutableSetValueKey: String{
//        return "relationPairElements"
//    }
}
public extension CoreDataSchemaRelationPair{
    var coreDataSchemaRelationPairElements : [CoreDataSchemaRelationPairElement]?{
        return elements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement})
    }
    var coreDataInstanceRelationPairs : [CoreDataInstanceRelationPair]?{
        return instances?.allObjects.map({$0 as! CoreDataInstanceRelationPair})
    }
}

