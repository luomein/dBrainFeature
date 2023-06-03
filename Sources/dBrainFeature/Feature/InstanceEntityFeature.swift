//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/29.
//

import Foundation
import ComposableArchitecture

public struct InstanceEntityFeature: ReducerProtocol{
    public enum Action:Equatable{
    }
    public var body: some ReducerProtocol<InstanceEntity, Action> {
        Reduce{ state, action in
            return .none
        }
    }
}
