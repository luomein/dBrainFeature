//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/20.
//

import Foundation
import IdentifiedCollections

public struct ValueTypeDataSource : Equatable{
    //public init(){}
    
        public var  schemaEntities :  IdentifiedArrayOf<SchemaEntity> = []
        public var instanceEntities : IdentifiedArrayOf<InstanceEntity> = []
        public var schemaRelationPairs : IdentifiedArrayOf<SchemaRelationPair> = []
        public var instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair> = []
    
    public init(schemaEntities: IdentifiedArrayOf<SchemaEntity> = []
                , instanceEntities: IdentifiedArrayOf<InstanceEntity> = []
                , schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair> = []
                , instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair> = []) {
        self.schemaEntities = schemaEntities
        self.instanceEntities = instanceEntities
        self.schemaRelationPairs = schemaRelationPairs
        self.instanceRelationPairs = instanceRelationPairs
    }
    public func getSubStateForSelectSchemaPair(of schemaEntity: SchemaEntity)->SchemaEntitySelectToPairFeature.State{
        return .init(schemaEntity: schemaEntity, allSchemaEntities: schemaEntities)
    }
    public func getSubStateForSelectInstancePair(
        instanceEntity: UUID
        , schemaRelationPair: UUID
        , schemaRelationPairElement: UUID)->InstanceEntitySelectToPairFeature.State{
        let instance = self.instanceEntities[id: instanceEntity]!
            let pair = self.schemaRelationPairs[id:schemaRelationPair]!
            let pairElement = pair.elements[id: schemaRelationPairElement]!
            let schemaInstances = self.instanceEntities.filter({$0.schemaID == pairElement.schemaID})
        return .init(instanceEntity: instance, allInstanceEntities: schemaInstances, schemaRelationPair: pair, schemaRelationPairElement: pairElement)
    }
    
    public func getSubState(of schemaEntity: SchemaEntity)->SchemaEntityFeature.State{
        
        let schemaRelationPairs = schemaRelationPairs.filter({$0.hasSchema(schemaEntity: schemaEntity)} )
        let instanceRelationPairs = instanceRelationPairs.filter({schemaRelationPairs[id:$0.schemaID] != nil})
                                                            
        return .init(schemaEntity: schemaEntity
                     , instanceEntities: instanceEntities.filter({$0.schemaID == schemaEntity.id})
                     , schemaRelationPairs: schemaRelationPairs
                     , instanceRelationPairs: instanceRelationPairs)
    }
}
