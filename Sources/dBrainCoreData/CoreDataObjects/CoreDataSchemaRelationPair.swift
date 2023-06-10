//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import CoreData

public extension CoreDataSchemaRelationPair{
    var coreDataSchemaRelationPairElements : [CoreDataSchemaRelationPairElement]?{
        return elements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement})
    }
    var coreDataInstanceRelationPairs : [CoreDataInstanceRelationPair]?{
        return instances?.allObjects.map({$0 as! CoreDataInstanceRelationPair})
    }
}

