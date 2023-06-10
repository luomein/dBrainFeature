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
    public func getPairedElements(of schema: SchemaEntity)->IdentifiedArrayOf<SchemaRelationPairElement>{
        if let firstPaired = elements.first(where: {$0.schemaID != schema.id}){
            return [firstPaired]
        }
        else{
            return elements
        }
    }
    
    public init(id: UUID, elements: IdentifiedArrayOf<SchemaRelationPairElement>) {
        self.id = id
        self.elements = elements
    }
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
    public init(id: UUID, schemaID: SchemaEntity.ID, type: SchemaRelationPairElementType = .toMany) {
        self.id = id
        self.schemaID = schemaID
        self.type = type
    }
}

