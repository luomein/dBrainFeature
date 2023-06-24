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
        
        public func getSubState(of schemaRelationPairElement: SchemaRelationPairElement)->SchemaRelationPairElementFeature.State{
            let schemaRelationPair = schemaRelationPairs.first(where: {$0.elements[id:schemaRelationPairElement.id] != nil})!
            let filteredInstanceRelationPairs = instanceRelationPairs.filter({$0.schemaID == schemaRelationPair.id})
                .filter({
                    $0.hasInstanceAndPairedSchemaElement(instance: instanceEntity, schemaElement: schemaRelationPairElement)
                })
            return .init(schemaEntity: schemaEntity
                         , instanceEntity: instanceEntity
                         , schemaRelationPair: schemaRelationPair
                         , schemaRelationPairElement: schemaRelationPairElement
                         , instanceRelationPairs: filteredInstanceRelationPairs)

        }
        
        
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
        public init(deleteInstance : @escaping  (InstanceEntity)->Void,
                    isSelected : @escaping (InstanceEntity,Bool)->Void){
            self.isSelected = isSelected
            self.deleteInstance = deleteInstance
        }
        
        var isSelected : (InstanceEntity,Bool)->Void
        var deleteInstance : (InstanceEntity)->Void
//        public init(createRelatedInstance: @escaping (SchemaRelationPairElement,InstanceEntity) -> Void) {
//            self.createRelatedInstance = createRelatedInstance
//        }
    }
    public var dataAgent : DataAgent
    
    public enum Action:Equatable{
        //case createRelatedInstance
        case delete
        case select(Bool)
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .delete:
                dataAgent.deleteInstance(state.instanceEntity)
            case .select(let value):
                dataAgent.isSelected(state.instanceEntity,value)
            }
            return .none
        }
    }
}
