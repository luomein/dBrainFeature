//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/29.
//

import Foundation
import ComposableArchitecture
//import SwiftUICytoscape

public struct InstanceEntity: Equatable, Identifiable, Hashable{
    public var id: UUID
    //public var schema: SchemaEntity
    public var schemaID : SchemaEntity.ID
    public var isSelected_depreciated : Bool = false
    
    public init(id: UUID, schemaID: SchemaEntity.ID , isSelected : Bool = false) {
        self.id = id
        self.schemaID = schemaID
        self.isSelected_depreciated = isSelected
    }
}

public struct InstanceRelationPair: Equatable, Identifiable{
    public var id: UUID
    public var elements: IdentifiedArrayOf<InstanceRelationPairElement>
    //public var schema: SchemaRelationPair
    public var schemaID: SchemaRelationPair.ID
    
    public init(id: UUID, elements: IdentifiedArrayOf<InstanceRelationPairElement>, schemaID: SchemaRelationPair.ID) {
        self.id = id
        self.elements = elements
        self.schemaID = schemaID
    }
    public func pairedInstance(of instance: InstanceEntity)->InstanceEntity.ID?{
        if let element = elements.first(where: {$0.instanceID == instance.id}){
            return elements.first(where: {$0 != element})!.instanceID
        }
        return nil
    }
    public func hasInstance(instance: InstanceEntity)->Bool{
        return elements.first(where: {$0.instanceID == instance.id}) != nil
    }
    public func hasRelation(instance0: InstanceEntity,instance1: InstanceEntity)->Bool{
        return (elements.first(where: {$0.instanceID == instance0.id}) != nil) && (elements.first(where: {$0.instanceID == instance1.id}) != nil)
    }
    public func hasInstanceAndPairedSchemaElement(instance: InstanceEntity, schemaElement: SchemaRelationPairElement)->Bool{
        return self.hasInstance(instance: instance) && (self.elements.first(where: {$0.instanceID != instance.id && $0.schemaID == schemaElement.id}) != nil )
    }
}

public struct InstanceRelationPairElement: Equatable, Identifiable{
    public var id: UUID
    public var instanceID: InstanceEntity.ID
    //public var schema: SchemaRelationPairElement
    public var schemaID: SchemaRelationPairElement.ID
    
    public init(id: UUID, instanceID: InstanceEntity.ID, schemaID: SchemaRelationPairElement.ID) {
        self.id = id
        self.instanceID = instanceID
        self.schemaID = schemaID
    }
}
