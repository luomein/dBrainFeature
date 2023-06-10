//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/29.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

//public struct InstanceEntityFilterCriteriaFeature: ReducerProtocol{
//    public struct State:Equatable, Identifiable{
//        public var schema : SchemaEntity
//        public var id : UUID{schema.id}
//        public var selectedInstances : IdentifiedArrayOf<InstanceEntity> = []
//        public var allInstances : IdentifiedArrayOf<InstanceEntity> = []
//    }
//    public enum Action:Equatable{
//        case selectInstances(Set<InstanceEntity> ) //,Bool)
//    }
//    public var body: some ReducerProtocol<State, Action> {
//        Reduce{ state, action in
//            switch action{
//            case .selectInstances(let value):
//                state.selectedInstances = IdentifiedArrayOf(uniqueElements: value)
////                if !select{
////                    state.selectedInstances.remove(id: instance.id)
////                }
////                else{
////                    state.selectedInstances.append(instance)
////                }
//            }
//            return .none
//        }
//    }
//}
//
//public struct InstanceEntityFilterFeature: ReducerProtocol{
//    //@Dependency(\.uuid) var uuid
//    @Dependency(\.dataAgent) public var dataAgent
//    
//    public struct State:Equatable{
//        var criterion : IdentifiedArrayOf<InstanceEntityFilterCriteriaFeature.State>
//        //var relatedSchemas : IdentifiedArrayOf<SchemaEntity>
//        var sourceSchema : SchemaEntity
//        var filteredInstances : IdentifiedArrayOf<InstanceEntity>
//        
//    }
//    public enum Action:Equatable{
//        case joinActionCriteriaFeature(InstanceEntityFilterCriteriaFeature.State.ID,InstanceEntityFilterCriteriaFeature.Action)
//    }
//    public var body: some ReducerProtocol<State, Action> {
//        Reduce{ state, action in
//            switch action{
//            case .joinActionCriteriaFeature(let id, let subAction):
//                switch subAction{
//                case .selectInstances:
//                    if state.criterion[id:id]!.selectedInstances.count == 0{
//                        //state.criterion = []
//                        for criteria in state.criterion{
//                            state.criterion[id: criteria.id]!.selectedInstances = []
//                        }
//                        state.filteredInstances = dataAgent.getUnfilteredInstance(of: state.sourceSchema)
//                    }
//                    else{
//                        let criteria = state.criterion[id: id]!
//                        state.filteredInstances = dataAgent.filterInstance(criteria: criteria, of: state.sourceSchema)
//                        for schema in state.criterion.map({$0.schema}){
//                            if schema.id == id {continue}
//                            let filteredInstance = dataAgent.filterInstance(criteria: criteria, of: schema)
//                            state.criterion[id: schema.id]!.selectedInstances = filteredInstance
//                        }
//                    }
//                }
//            }
//            return .none
//        }
//        .forEach(\.criterion, action: /Action.joinActionCriteriaFeature) {
//            InstanceEntityFilterCriteriaFeature()
//        }
//    }
//}
