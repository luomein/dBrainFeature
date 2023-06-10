//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import dBrainFeature
import CoreData

public extension CoreDataSchemaRelationPairElement{
    struct Converter{
        public var schemaRelationPairElement : SchemaRelationPairElement{
            return .init(id: item.id!, schemaID: item.schema!.id!, type: .init(rawValue: item.type ?? SchemaRelationPairElement.SchemaRelationPairElementType.toMany.rawValue)!)
        }
        
        public typealias T = CoreDataSchemaRelationPairElement
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var converter: Converter{
        return .init(item: self)
    }
}
