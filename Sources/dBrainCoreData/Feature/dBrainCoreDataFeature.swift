//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/2.
//

import Foundation
import ComposableArchitecture
import dBrainFeature
import CoreData

//public struct dBrainCoreDataFeature: ReducerProtocol{
//    
//    @Dependency(\.uuid) var uuid
//    var viewContext : NSManagedObjectContext
//    
//    public struct State:Equatable{
//        var dBrainFeatureState : dBrainFeature.State
//        
//        public init(entities: [CoreDataInstanceEntity]) {
//            dBrainFeatureState = .init(schemas: [], schemaRelationPairs: [], entities: .init(uniqueElements: entities.map({$0.mapped})), relationPairs: [])
//        }
//    }
//    public enum Action:Equatable{
//        case createInstance(of : CoreDataSchemaEntity)
//    }
//    
//    public var body: some ReducerProtocol<State, Action> {
//        Reduce{ state, action in
//            switch action{
//            case .createInstance(let schema):
//                CoreDataInstanceEntity.createInstance(of: schema, viewContext: viewContext)
//            }
//            return .none
//        }
//    }
//}
