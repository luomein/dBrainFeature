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

public extension CoreDataSchemaEntity{
    struct Converter{
        public var schemaEntity : SchemaEntity{
            return .init(id: item.id!, name: item.name!)
        }
        public var instanceEntities: IdentifiedArrayOf<InstanceEntity>{
            return .init(uniqueElements: item.coreDataInstanceEntities?.map({$0.converter.instanceEntity}) ?? [])
        }
        public var schemaRelationPairs : IdentifiedArrayOf<SchemaRelationPair>{
            let schemaRelationPairsSet = Set(item.coreDataSchemaRelationPairElements?.map({$0.pair!}) ?? [])
            return .init(uniqueElements: schemaRelationPairsSet.map({
                $0.converter.schemaRelationPair
            }) )
        }
        public var instanceRelationPairs : IdentifiedArrayOf<InstanceRelationPair>{
            let schemaRelationPairsSet = Set(item.coreDataSchemaRelationPairElements?.map({$0.pair!}) ?? [])
            let instanceRelationPairSet = schemaRelationPairsSet.flatMap({$0.coreDataInstanceRelationPairs ?? []})
            return .init(uniqueElements: instanceRelationPairSet.map({$0.converter.instanceRelationPair}))
        }
        
        public typealias T = CoreDataSchemaEntity
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var converter: Converter{
        return .init(item: self)
    }
}
