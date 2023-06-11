//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import ComposableArchitecture


public struct SchemaRelationPairElementFeature: ReducerProtocol{
    public init(dataAgent: DataAgent){
        self.dataAgent = dataAgent
    }
    public struct State:Equatable{
        public var  schemaEntity : SchemaEntity
        public var instanceEntity : InstanceEntity
        public var schemaRelationPair  :  SchemaRelationPair
        public var schemaRelationPairElement  :  SchemaRelationPairElement
        public var instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair>
        
        public init(schemaEntity: SchemaEntity, instanceEntity:  InstanceEntity
                    , schemaRelationPair: SchemaRelationPair, schemaRelationPairElement  :  SchemaRelationPairElement
                    , instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair>) {
            self.schemaEntity = schemaEntity
            self.instanceEntity = instanceEntity
            self.schemaRelationPair = schemaRelationPair
            self.schemaRelationPairElement = schemaRelationPairElement
            self.instanceRelationPairs = instanceRelationPairs
            
            assert(schemaRelationPair.elements.first(where: {$0 != schemaRelationPairElement})!.schemaID == schemaEntity.id)
            assert(instanceRelationPairs.first(where: {$0.elements.filter( {
                $0.instanceID != instanceEntity.id && $0.schemaID != schemaRelationPairElement.id
            }).count > 0}) == nil)
            
            assert( instanceEntity.schemaID == schemaEntity.id)
            assert(instanceRelationPairs.first(where: {schemaRelationPair.id != $0.schemaID}) == nil)
            assert(instanceRelationPairs.first(where: {$0.elements.filter( { $0.instanceID == instanceEntity.id}).count == 0}) == nil)
            assert(schemaRelationPair.elements.filter({schemaEntity.id == $0.schemaID}).count > 0)
            assert(instanceRelationPairs.first(where: { instanceRelationPair in
                instanceRelationPair.elements.first(where: { instanceRelationPairElement in
                    
                        schemaRelationPair.elements[id: instanceRelationPairElement.schemaID] == nil
                    
                }) != nil
            }) == nil )
        }
    }
    public struct DataAgent{
         var createRelatedInstance : (SchemaRelationPairElement, SchemaRelationPair ,InstanceEntity)->Void
        var delete : (SchemaRelationPair)->Void
        public init(createRelatedInstance: @escaping (SchemaRelationPairElement, SchemaRelationPair ,InstanceEntity) -> Void,
                    delete: @escaping (  SchemaRelationPair  ) -> Void) {
            self.createRelatedInstance = createRelatedInstance
            self.delete = delete
        }
    }
    public var dataAgent : DataAgent
    
    public enum Action:Equatable{
        case createRelatedInstance
        case delete
        case removeRelation(InstanceRelationPair)
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .createRelatedInstance:
                dataAgent.createRelatedInstance(state.schemaRelationPairElement
                                                , state.schemaRelationPair
                                                , state.instanceEntity)
            case.delete:
                dataAgent.delete(state.schemaRelationPair)
            case .removeRelation(let pair):
                fatalError()
            }
            return .none
        }
    }
}
