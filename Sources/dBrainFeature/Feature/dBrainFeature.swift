//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/5/29.
//

import Foundation
import ComposableArchitecture


public struct dBrainFeature: ReducerProtocol{
    
    @Dependency(\.uuid) var uuid
    
    public struct State:Equatable{
        var schemas : IdentifiedArrayOf<SchemaEntity>
        var schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>
        
        var entities: IdentifiedArrayOf<InstanceEntity>
        var relationPairs: IdentifiedArrayOf<InstanceRelationPair>
        
        var filteredEntities: IdentifiedArrayOf<InstanceEntity> = []
        var filteredInstanceRelationElements: IdentifiedArrayOf<InstanceRelationPairElement> = []
        var filteredSchemaRelationElements: IdentifiedArrayOf<SchemaRelationPairElement> = []
        
        var browsingEntity : InstanceEntity?
        
        public init(schemas: IdentifiedArrayOf<SchemaEntity>, schemaRelationPairs: IdentifiedArrayOf<SchemaRelationPair>, entities: IdentifiedArrayOf<InstanceEntity>, relationPairs: IdentifiedArrayOf<InstanceRelationPair>, filteredEntities: IdentifiedArrayOf<InstanceEntity>=[]) {
            self.schemas = schemas
            self.schemaRelationPairs = schemaRelationPairs
            self.entities = entities
            self.relationPairs = relationPairs
            self.filteredEntities = filteredEntities
        }
    }
    
    public enum Action:Equatable{
        case filterEntities(FilterEntitiesCriteria)
        case filterInstanceRelationElements(FilterInstanceRelationElementsCriteria)
        case filterSchemaRelationElements(FilterSchemaRelationElementsCriteria)
        
        case addSchemaRelation(SchemaEntity.ID,SchemaEntity.ID)
        
        case browseEntity(InstanceEntity?)
        case browsingEntityAddSchemaRelation(SchemaEntity.ID)
        case browsingEntityAddRelationToNewInstance(SchemaRelationPair,SchemaRelationPairElement)
        
        case checkConsistency
    }
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .filterEntities(let criteria):
                state.filteredEntities = filterEntities(entities: state.entities, relationPairs: state.relationPairs, criteria: criteria)
            case .filterInstanceRelationElements(let criteria):
                state.filteredInstanceRelationElements = filterInstanceRelationElements(relationPairs: state.relationPairs, criteria: criteria)
            case .filterSchemaRelationElements(let criteria):
                state.filteredSchemaRelationElements = filterSchemaRelationElements(relationPairs: state.relationPairs, criteria: criteria, schemaRelationPairs: state.schemaRelationPairs)
            case .addSchemaRelation(let lhs, let rhs):
                state.schemaRelationPairs.append(.init(id: uuid(), elements: .init(uniqueElements: [
                    .init(id: uuid(), schemaID: lhs)
                    ,.init(id: uuid(), schemaID: rhs)
                ])))
            case .browseEntity(let value):
                state.browsingEntity = value
            case .browsingEntityAddSchemaRelation(let value):
                return .send(.addSchemaRelation(state.browsingEntity!.schemaID, value))
            case .browsingEntityAddRelationToNewInstance(let schemaPair, let schemaElement):
                let newInstance = InstanceEntity(id: uuid(), schemaID: schemaElement.schemaID )
                let relationSchemaElementOfSelf = schemaPair.elements.first {$0 != schemaElement}!
                state.entities.append(newInstance)
                state.relationPairs.append(.init(id: uuid()
                                                 , elements: .init(uniqueElements: [
                                                    .init(id: uuid(), instanceID: state.browsingEntity!.id, schemaID: relationSchemaElementOfSelf.id)
                                                    ,.init(id: uuid(), instanceID: newInstance.id, schemaID: schemaElement.id)
                                                 ])
                                                 , schemaID: schemaPair.id))
            case .checkConsistency:
                let result = checkConsistency(schemas: state.schemas
                                 , schemaRelationPairs: state.schemaRelationPairs
                                 , entities: state.entities
                                     , relationPairs: state.relationPairs)
                if result != .consistent {
                    print(result)
                    fatalError()
                    
                }
                return .none
            }
            return .send(.checkConsistency)
        }
    }
}
