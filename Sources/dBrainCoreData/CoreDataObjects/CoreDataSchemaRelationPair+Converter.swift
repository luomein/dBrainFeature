//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import dBrainFeature
import CoreData

public extension CoreDataSchemaRelationPair{
    struct Converter{
        public var schemaRelationPair : SchemaRelationPair{
            return .init(id: item.id!, elements: .init(uniqueElements: item.coreDataSchemaRelationPairElements!.map({$0.converter.schemaRelationPairElement})))
        }
        
        public typealias T = CoreDataSchemaRelationPair
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var converter: Converter{
        return .init(item: self)
    }
}

