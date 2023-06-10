//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//


import Foundation
import dBrainFeature
import CoreData
import IdentifiedCollections

public extension CoreDataInstanceRelationPairElement{
    struct Converter{
        public var schemaRelationPairElement : SchemaRelationPairElement{
            let itemSchema = item.schema!
            return .init(id: itemSchema.id!, schemaID: itemSchema.schema!.id!, type: .init(rawValue: itemSchema.type ?? SchemaRelationPairElement.SchemaRelationPairElementType.toMany.rawValue)!)
        }
        public var instanceRelationPairElement : InstanceRelationPairElement{
            return .init(id: item.id!, instanceID: item.instance!.id!, schemaID: item.schema!.id!)
        }
        
        public typealias T = CoreDataInstanceRelationPairElement
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var converter: Converter{
        return .init(item: self)
    }
}
