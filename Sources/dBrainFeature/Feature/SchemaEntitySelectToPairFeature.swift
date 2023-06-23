//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/11.
//

import Foundation

import ComposableArchitecture

public struct SchemaEntitySelectToPairFeature: ReducerProtocol{
//    public init(dataAgent: DataAgent){
//        self.dataAgent = dataAgent
//    }
    public init(){}
    public struct State:Equatable{
        public var  schemaEntity : SchemaEntity
        public var allSchemaEntities : IdentifiedArrayOf<SchemaEntity>
        //public var selectedSchemaEntities : Set<SchemaEntity> = []
        
        
        public init(schemaEntity: SchemaEntity, allSchemaEntities: IdentifiedArrayOf<SchemaEntity> ) {
            self.schemaEntity = schemaEntity
            self.allSchemaEntities = allSchemaEntities
             
        }
    }
    public struct DataAgent{
        var createRelation : (SchemaEntity,Set<SchemaEntity>)->Void
        public init(
                    createRelation: @escaping (SchemaEntity,Set<SchemaEntity>) -> Void) {
            self.createRelation = createRelation
        }
    }
    //public var dataAgent : DataAgent
    
    public enum Action:Equatable{
        //case createRelation
        //case selectSchemas(Set<SchemaEntity>)
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
//            switch action{
//            case .selectSchemas(let value):
//                state.selectedSchemaEntities = value
//                print(state.allSchemaEntities)
//                print(state.selectedSchemaEntities,state.selectedSchemaEntities.count)
////            case .createRelation:
////
////                dataAgent.createRelation(state.schemaEntity,state.selectedSchemaEntities)
////
//            }
            return .none
        }
    }
}
