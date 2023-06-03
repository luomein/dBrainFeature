//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/30.
//

import Foundation
import ComposableArchitecture

public enum FilterSchemaRelationElementsCriteria: Equatable{
    case ofEntity(InstanceEntity)
}
public enum FilterInstanceRelationElementsCriteria: Equatable{
    case ofEntity(InstanceEntity)
}
public enum FilterEntitiesCriteria:Equatable{
    case ofSchema(SchemaEntity)
    case ofEntityRelation(InstanceEntity, SchemaRelationPairElement)
    
}

public func filterSchemaRelationElements(relationPairs: IdentifiedArrayOf<InstanceRelationPair>
                                           ,criteria:FilterSchemaRelationElementsCriteria
                                         ,schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>
)->IdentifiedArrayOf<SchemaRelationPairElement>{
    switch criteria {
    case .ofEntity(let entity):
        //var result = [SchemaRelationPairElement]()
        let filteredRelationPairElements = filterInstanceRelationElements(relationPairs: relationPairs, criteria: .ofEntity(entity))
            //.map({$0.schema})
            .map({$0.schemaID})
        let filteredSchemaRelationPairElements = schemaRelationPairs.compactMap({
            $0.elements.elements.filter({filteredRelationPairElements.contains($0.id)})
        }).flatMap({$0})
//            .reduce(into: IdentifiedArrayOf<SchemaRelationPairElement>(uniqueElements: [])) {
//                if $0[id:$1.id] == nil{$0[id: $1.id] = $1}
//            }
        return .init(uniqueElements: filteredSchemaRelationPairElements) //filteredSchemaRelationPairElements
    }
    
}
public func filterInstanceRelationElements(relationPairs: IdentifiedArrayOf<InstanceRelationPair>
                                           ,criteria:FilterInstanceRelationElementsCriteria
)->IdentifiedArrayOf<InstanceRelationPairElement>{
    switch criteria {
    case .ofEntity(let entity):
        let filteredRelationPairs = relationPairs.filter {$0.elements.first{$0.instanceID == entity.id} != nil}
        let filteredRelationPairElements = filteredRelationPairs.map {
            $0.elements.first {
                $0.instanceID != entity.id
            }!
        }
        return IdentifiedArrayOf(uniqueElements: filteredRelationPairElements)
    }
    
}
public func filterEntities(entities: IdentifiedArrayOf<InstanceEntity>
                           ,relationPairs: IdentifiedArrayOf<InstanceRelationPair>
                           ,criteria: FilterEntitiesCriteria)->IdentifiedArrayOf<InstanceEntity>{
    switch criteria {
    case .ofSchema(let schemaEntity):
        return entities.filter {
            $0.schemaID == schemaEntity.id
        }
    case .ofEntityRelation(let entity, let schemaRelationPairElement):
        let filteredRelationPairs = relationPairs.filter {$0.elements.first{$0.instanceID == entity.id} != nil}
        let filteredRelationPairElementsEntity = filteredRelationPairs.map {
            $0.elements.first {
                $0.schemaID == schemaRelationPairElement.id
            }!.instanceID
        }
            .map({
                entities[id: $0]!
            })
        return IdentifiedArrayOf(uniqueElements: filteredRelationPairElementsEntity)
    }
    
}
