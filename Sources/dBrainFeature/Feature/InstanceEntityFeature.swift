//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import ComposableArchitecture

public struct InstanceEntityFeature: ReducerProtocol{
    public init(dataAgent: DataAgent){
        self.dataAgent = dataAgent
    }
    public struct State:Equatable{
        public var  schemaEntity : SchemaEntity
        public var instanceEntity : InstanceEntity
        public var schemaRelationPairs : IdentifiedArrayOf<SchemaRelationPair>
        public var instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair>
        
        public init(schemaEntity: SchemaEntity, instanceEntity:  InstanceEntity, schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>, instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair>) {
            self.schemaEntity = schemaEntity
            self.instanceEntity = instanceEntity
            self.schemaRelationPairs = schemaRelationPairs
            self.instanceRelationPairs = instanceRelationPairs
            
            assert( instanceEntity.schemaID == schemaEntity.id)
            assert(instanceRelationPairs.first(where: {schemaRelationPairs[id:$0.schemaID] == nil}) == nil)
            assert(instanceRelationPairs.first(where: {$0.elements.filter( { $0.instanceID == instanceEntity.id}).count == 0}) == nil)
            assert(schemaRelationPairs.first(where: {$0.elements.filter({schemaEntity.id == $0.schemaID}).count == 0}) == nil)
            assert(instanceRelationPairs.first(where: { instanceRelationPair in
                instanceRelationPair.elements.first(where: { instanceRelationPairElement in
                    schemaRelationPairs.first(where: { schemaRelationPair in
                        schemaRelationPair.elements[id: instanceRelationPairElement.schemaID] == nil
                    }) == nil
                }) == nil
            }) == nil )
        }
    }
    public struct DataAgent{
         
//        var createRelatedInstance : (SchemaRelationPairElement,InstanceEntity)->Void
//        public init(createRelatedInstance: @escaping (SchemaRelationPairElement,InstanceEntity) -> Void) {
//            self.createRelatedInstance = createRelatedInstance
//        }
    }
    public var dataAgent : DataAgent
    
    public enum Action:Equatable{
        //case createRelatedInstance
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
//            switch action{
//            case .createRelatedInstance:
//                dataAgent.createRelatedInstance(state.schemaEntity)
//            }
            return .none
        }
    }
}
