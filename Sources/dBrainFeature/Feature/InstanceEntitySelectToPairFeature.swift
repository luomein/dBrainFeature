//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/23.
//

import Foundation
import ComposableArchitecture

public struct InstanceEntitySelectToPairFeature: ReducerProtocol{
//    public init(dataAgent: DataAgent){
//        self.dataAgent = dataAgent
//    }
    public init(){}
    public struct State:Equatable{
        public var  instanceEntity : InstanceEntity
        public var allInstanceEntities : IdentifiedArrayOf<InstanceEntity>
        public var schemaRelationPair: SchemaRelationPair
        public var schemaRelationPairElement : SchemaRelationPairElement
        //public var selectedInstanceEntities : Set<InstanceEntity> = []
        
        public init(instanceEntity: InstanceEntity, allInstanceEntities: IdentifiedArrayOf<InstanceEntity>, schemaRelationPair: SchemaRelationPair, schemaRelationPairElement: SchemaRelationPairElement) {
            self.instanceEntity = instanceEntity
            self.allInstanceEntities = allInstanceEntities
            self.schemaRelationPair = schemaRelationPair
            self.schemaRelationPairElement = schemaRelationPairElement
        }
    }
    public struct DataAgent{
        var createRelation : (InstanceEntity,Set<InstanceEntity>,SchemaRelationPair,SchemaRelationPairElement)->Void
        public init(
                    createRelation: @escaping (InstanceEntity,Set<InstanceEntity>,SchemaRelationPair,SchemaRelationPairElement) -> Void) {
            self.createRelation = createRelation
        }
    }
    //public var dataAgent : DataAgent
    
    public enum Action:Equatable{
        //case createRelation
        //case selectInstances(Set<InstanceEntity>)
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            
            return .none
        }
    }
}
