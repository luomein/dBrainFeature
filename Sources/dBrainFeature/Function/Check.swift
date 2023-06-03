//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/30.
//

import Foundation
import ComposableArchitecture

public enum ConsistencyState: Equatable{
    case consistent
    case notListedSchemaID([SchemaEntity.ID])
    case notListedInstanceEntityID([InstanceEntity.ID])
    case instanceRelationToSelf(IdentifiedArrayOf<InstanceRelationPair>)
    case instanceRelationPairNotFollowSchema(IdentifiedArrayOf<InstanceRelationPair>)
}
public func checkNotListedSchemaID(schemas: IdentifiedArrayOf<SchemaEntity>, schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>)->[SchemaEntity.ID]?{
    let notListedSchemaEntity = schemaRelationPairs
        .flatMap{
            //$0.elements.filter{!schemas.contains($0.schema)}
            $0.elements.filter{schemas[id:$0.schemaID] == nil}
        }
        .map({$0.schemaID})
        
    guard notListedSchemaEntity.count > 0 else {return nil}
    return  notListedSchemaEntity
}
public func checkNotListedInstanceEntityID(entities: IdentifiedArrayOf<InstanceEntity>, relationPairs: IdentifiedArrayOf<InstanceRelationPair>)->[InstanceEntity.ID]?{
    let notListedInstanceEntity = relationPairs
        .flatMap {
            $0.elements.filter{ entities[id:$0.instanceID] == nil}
        }
        .map({$0.instanceID})
    guard notListedInstanceEntity.count > 0 else {return nil}
    return notListedInstanceEntity
}
public func checkInstanceRelationToSelf(relationPairs: IdentifiedArrayOf<InstanceRelationPair>)->IdentifiedArrayOf<InstanceRelationPair>?{
    let instanceRelationToSelf = relationPairs
        .filter {
            $0.elements.reduce(into: [InstanceEntity.ID](), {
                if !$0.contains($1.instanceID){$0.append($1.instanceID)}
            }).count < $0.elements.count
        }
    guard instanceRelationToSelf.count > 0 else {return nil}
    return IdentifiedArrayOf(uniqueElements: instanceRelationToSelf)
}
public func checkInstanceRelationPairNotFollowSchema(relationPairs: IdentifiedArrayOf<InstanceRelationPair>
                                                     ,schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>
                                                     ,entities: IdentifiedArrayOf<InstanceEntity>
)->IdentifiedArrayOf<InstanceRelationPair>?{
    let instanceRelationPairNotFollowSchema = relationPairs
        .filter { //relationPair in
            schemaRelationPairs[id: $0.schemaID]!.elements != .init(uniqueElements: $0.elements.map( {
                
                .init(id: $0.schemaID, schemaID: entities[id:$0.instanceID]!.schemaID)
                
            }) )

        }
    
    guard instanceRelationPairNotFollowSchema.count > 0 else {return nil}
    return IdentifiedArrayOf(uniqueElements: instanceRelationPairNotFollowSchema)
}
public func checkConsistency(schemas: IdentifiedArrayOf<SchemaEntity>, schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>, entities: IdentifiedArrayOf<InstanceEntity>, relationPairs: IdentifiedArrayOf<InstanceRelationPair>)->ConsistencyState{
    
    if let notListedSchemaID = checkNotListedSchemaID(schemas: schemas, schemaRelationPairs: schemaRelationPairs){
        return .notListedSchemaID(notListedSchemaID)
    }
    if let notListedInstanceEntityID = checkNotListedInstanceEntityID(entities: entities, relationPairs: relationPairs){
        return .notListedInstanceEntityID(notListedInstanceEntityID)
    }
    if let instanceRelationToSelf = checkInstanceRelationToSelf(relationPairs: relationPairs){
        return .instanceRelationToSelf(instanceRelationToSelf)
    }
    if let instanceRelationPairNotFollowSchema = checkInstanceRelationPairNotFollowSchema(relationPairs: relationPairs, schemaRelationPairs: schemaRelationPairs, entities: entities){
        return .instanceRelationPairNotFollowSchema(instanceRelationPairNotFollowSchema)
    }
    
    
    return ConsistencyState.consistent
}
