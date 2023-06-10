//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/29.
//

import Foundation
import ComposableArchitecture

public struct SchemaEntity: Equatable, Identifiable{
    public var id: UUID
    public var name: String
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    //public var entities: IdentifiedArrayOf<InstanceEntity>
}

public struct SchemaRelationPair: Equatable, Identifiable{
    public var id: UUID
    public var elements: IdentifiedArrayOf<SchemaRelationPairElement>
}

public struct SchemaRelationPairElement: Equatable, Identifiable{
    public var id: UUID
    //public var schema: SchemaEntity
    public var schemaID: SchemaEntity.ID
    public var type: SchemaRelationPairElementType = .toMany
    
    public enum SchemaRelationPairElementType: String{
        case toOne
        case toMany
    }
}

