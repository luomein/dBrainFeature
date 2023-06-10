//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

public struct RegionalFeature: ReducerProtocol{
    //@Dependency(\.dataAgent) public var dataAgent
    public var dataAgent : DataAgentProtocol
    
    
    public struct State:Equatable{
        var  schemaEntities : IdentifiedArrayOf<SchemaEntity>
        var instanceEntities : IdentifiedArrayOf<InstanceEntity>
    }
    public enum Action:Equatable{
        case createInstance(of: SchemaEntity)
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .createInstance(let schema):
                dataAgent.createInstance(of: schema)
                
            }
            return .none
        }
    }
}
