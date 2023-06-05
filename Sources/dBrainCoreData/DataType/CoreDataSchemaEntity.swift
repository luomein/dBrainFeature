//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import Foundation

extension CoreDataSchemaEntity:CoreDataProperty{
    public var setSelectItemByType: SelectItem.SetSelectItemByType {
        return .coreDataSchemaEntity(self)
    }
    
    public static var entityName : String{
        return "CoreDataSchemaEntity"
        //why Self.entity().name possibliy be nil
    }
//    public static var mutableSetValueKey: String{
//        return "relationPairElements"
//    }
}

public extension CoreDataSchemaEntity{
    var coreDataSchemaRelationPairElements: [CoreDataSchemaRelationPairElement]?{
        return relationPairElements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement})
    }
    
    var coreDataInstanceEntities: [CoreDataInstanceEntity]?{
        return self.instances?.allObjects.map({$0 as! CoreDataInstanceEntity})
    }
}
