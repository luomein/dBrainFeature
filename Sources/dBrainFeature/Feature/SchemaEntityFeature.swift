//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/29.
//

import Foundation
import ComposableArchitecture

public struct SchemaEntityFeature: ReducerProtocol{
    public init(dataAgent: DataAgent){
        self.dataAgent = dataAgent
    }
    public struct State:Equatable{
        public var  schemaEntity : SchemaEntity
        public var instanceEntities : IdentifiedArrayOf<InstanceEntity>
        public var schemaRelationPairs : IdentifiedArrayOf<SchemaRelationPair>
        public var instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair>
        
        public func getSubState(of instance: InstanceEntity)->InstanceEntityFeature.State{
            return .init(schemaEntity: schemaEntity
                         , instanceEntity: instance
                         , schemaRelationPairs: schemaRelationPairs
                         , instanceRelationPairs: instanceRelationPairs.filter({$0.hasInstance(instance: instance)}))
        }
        
        public init(schemaEntity: SchemaEntity, instanceEntities: IdentifiedArrayOf<InstanceEntity>, schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>, instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair>) {
            self.schemaEntity = schemaEntity
            self.instanceEntities = instanceEntities
            self.schemaRelationPairs = schemaRelationPairs
            self.instanceRelationPairs = instanceRelationPairs
            
            assert(instanceEntities.first(where: {$0.schemaID != schemaEntity.id}) == nil)
            assert(instanceRelationPairs.first(where: {schemaRelationPairs[id:$0.schemaID] == nil}) == nil)
            assert(instanceRelationPairs.first(where: {$0.elements.filter( {instanceEntities[id:$0.instanceID] != nil}).count == 0}) == nil)
            assert(schemaRelationPairs.first(where: {$0.elements.filter({schemaEntity.id == $0.schemaID}).count == 0}) == nil)
//            assert(instanceRelationPairs.first(where: { instanceRelationPair in
//                instanceRelationPair.elements.first(where: { instanceRelationPairElement in
//                    schemaRelationPairs.first(where: { schemaRelationPair in
//                        schemaRelationPair.elements[id: instanceRelationPairElement.schemaID] == nil
//                    }) == nil
//                }) == nil
//            }) == nil )
            assert(instanceRelationPairs.first(where: { instanceRelationPair in
                instanceRelationPair.elements.first(where: { instanceRelationPairElement in
                    let count = schemaRelationPairs.filter( { schemaRelationPair in
                        //print(schemaRelationPair)
                        return schemaRelationPair.elements[id: instanceRelationPairElement.schemaID] != nil
                    }).count
                    //print(instanceRelationPairElement, count)
                    return count != 1
                }) != nil
            }) == nil )
        }
    }
    public struct DataAgent{
        var createInstance : (SchemaEntity)->Void
        var createRelation : (SchemaEntity)->Void
        var deleteSchema: (SchemaEntity)->Void
        public init(createInstance: @escaping (SchemaEntity) -> Void,
                    createRelation: @escaping (SchemaEntity) -> Void,
                    deleteSchema: @escaping (SchemaEntity) -> Void
        ) {
            self.createInstance = createInstance
            self.createRelation = createRelation
            self.deleteSchema = deleteSchema
        }
    }
    public var dataAgent : DataAgent
    
    public enum Action:Equatable{
        case createInstance
        case createRelation
        case delete
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .createInstance:
                dataAgent.createInstance(state.schemaEntity)
            case .createRelation:
                dataAgent.createRelation(state.schemaEntity)
            case .delete:
                dataAgent.deleteSchema(state.schemaEntity)
            }
            return .none
        }
    }
}
