//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import CoreData

public extension CoreDataInstanceRelationPair{
    var coreDataInstanceRelationPairElements : [CoreDataInstanceRelationPairElement]?{
        return elements?.allObjects.map({$0 as! CoreDataInstanceRelationPairElement})
    }
}
