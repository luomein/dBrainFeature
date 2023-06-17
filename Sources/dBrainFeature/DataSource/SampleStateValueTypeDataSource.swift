//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/17.
//

import Foundation
import SwiftUI
import IdentifiedCollections
import ComposableArchitecture

public extension SampleStateValueTypeDataSourceFeature{
    func deleteSchemaRelationPair(pair: SchemaRelationPair, dataSource: inout State){
       dataSource.instanceRelationPairs.removeAll {$0.schemaID == pair.id}
       dataSource.schemaRelationPairs.remove(id: pair.id)
   }
    func createRelatedInstance(of schemaRelationPairElement: SchemaRelationPairElement, in pair: SchemaRelationPair, from instance: InstanceEntity, dataSource: inout State){
       let newInstance = InstanceEntity(id: UUID(), schemaID: schemaRelationPairElement.schemaID)
       let newPairInstanceElement = InstanceRelationPairElement(id: UUID(), instanceID: newInstance.id, schemaID: schemaRelationPairElement.id)
       
       let pairedSchemaRelationPairElement = pair.elements.first(where: {$0.id != schemaRelationPairElement.id})!
       let pairedInstanceRelationPairElement = InstanceRelationPairElement(id: UUID(), instanceID: instance.id, schemaID: pairedSchemaRelationPairElement.id)
       
       let newPairInstance = InstanceRelationPair(id: UUID(), elements: .init(uniqueElements: [newPairInstanceElement, pairedInstanceRelationPairElement]), schemaID: pair.id)
       
       dataSource.instanceEntities.append(newInstance)
       dataSource.instanceRelationPairs.append(newPairInstance)
   }
   
   func deleteInstance(of instance: InstanceEntity, dataSource: inout State){
       let instanceRelationPairs = dataSource.instanceRelationPairs.filter{$0.hasInstance(instance: instance)}
       dataSource.instanceRelationPairs.removeAll {instanceRelationPairs.contains($0)}
       dataSource.instanceEntities.remove(instance)
   }
   func setInstanceSelected(of instance: InstanceEntity, isSelected: Bool, dataSource: inout State){
       dataSource.instanceEntities[id: instance.id]!.isSelected = isSelected
   }
}
public struct SampleStateValueTypeDataSourceFeature : ReducerProtocol{
    public init(){}
    public struct State : Equatable{
        public init(){}
            public var  schemaEntities :  IdentifiedArrayOf<SchemaEntity> = []
            public var instanceEntities : IdentifiedArrayOf<InstanceEntity> = []
            public var schemaRelationPairs : IdentifiedArrayOf<SchemaRelationPair> = []
            public var instanceRelationPairs: IdentifiedArrayOf<InstanceRelationPair> = []
         
        public func getSubState(of schemaEntity: SchemaEntity)->SchemaEntityFeature.State{
            
            let schemaRelationPairs = schemaRelationPairs.filter({$0.hasSchema(schemaEntity: schemaEntity)} )
            let instanceRelationPairs = instanceRelationPairs.filter({schemaRelationPairs[id:$0.schemaID] != nil})
                                                                
            return .init(schemaEntity: schemaEntity
                         , instanceEntities: instanceEntities.filter({$0.schemaID == schemaEntity.id})
                         , schemaRelationPairs: schemaRelationPairs
                         , instanceRelationPairs: instanceRelationPairs)
        }
    }
    public enum Action{
        case createSchema
        case createRelation(SchemaEntity)
        case createInstance(SchemaEntity)
        case deleteSchema(SchemaEntity)
        case setInstanceSelected(InstanceEntity,  Bool)
        case deleteInstance( InstanceEntity)
        case createRelatedInstance(SchemaRelationPairElement, SchemaRelationPair,  InstanceEntity)
        case deleteSchemaRelationPair(SchemaRelationPair)
    }
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce{ state, action in
            switch action{
            case .deleteSchemaRelationPair(let pair):
                deleteSchemaRelationPair(pair: pair, dataSource: &state)
            case .createRelatedInstance(let element, let pair, let instance):
                createRelatedInstance(of: element, in: pair, from: instance, dataSource: &state)
            case .deleteInstance(let instance):
                deleteInstance(of: instance, dataSource: &state)
            case .setInstanceSelected(let instance, let isSelected):
                setInstanceSelected(of: instance, isSelected: isSelected, dataSource: &state)
            case .createSchema:
                state.schemaEntities.append(.init(id: UUID(), name: "\(Int.random(in: 0...1000))"))
            case .deleteSchema(let schema):
                let schemaRelationPairs = state.schemaRelationPairs.filter({$0.hasSchema(schemaEntity: schema)} )
                let instanceRelationPairs = state.instanceRelationPairs.filter({schemaRelationPairs[id:$0.schemaID] != nil})
                let instanceEntities = state.instanceEntities.filter({$0.schemaID == schema.id})
                state.schemaRelationPairs.removeAll(where: {schemaRelationPairs.contains($0)})
                state.instanceRelationPairs.removeAll {instanceRelationPairs.contains($0)}
                state.instanceEntities.removeAll {instanceEntities.contains($0)}
                state.schemaEntities.remove(schema)
            case .createInstance(let schema):
                state.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
            case .createRelation(let schema):
                let newSchema = SchemaEntity(id: UUID(), name: "\(Int.random(in: 0...1000))")
                 state.schemaEntities.append(newSchema)
                state.schemaRelationPairs.append(.init(id: UUID(), elements: [
                    .init(id: UUID(), schemaID: schema.id)
                    ,.init(id: UUID(), schemaID: newSchema.id)
                ]))
            }
            return .none
        }
    }
}

struct SampleStateValueTypeDataSource_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SampleStateValueTypeDataSource<SchemaEntityFeatureWrapperView, SchemaEntityFeature.State>(componentView: SchemaEntityFeatureWrapperView.init)
        }
    }
}

public struct SampleStateValueTypeDataSource<T:View, S:Equatable>: View {
    let store : StoreOf<SampleStateValueTypeDataSourceFeature>

    var componentView : (S)->T
    public init(componentView : @escaping (S)->T, store: StoreOf<SampleStateValueTypeDataSourceFeature>? = nil) {
        self.componentView = componentView
        if let store = store{
            self.store = store
        }
        else{
            self.store = .init(initialState: .init(), reducer: {SampleStateValueTypeDataSourceFeature()})
        }
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let createRelation : (SchemaEntity)->Void = { viewStore.send(.createRelation($0)) }
            let createInstance : (SchemaEntity)->Void = { viewStore.send(.createInstance($0)) }
            let deleteSchema : (SchemaEntity)->Void = { viewStore.send(.deleteSchema($0)) }
            let deleteInstance : (InstanceEntity) ->Void = {viewStore.send(.deleteInstance($0))}
            let setInstanceSelected :( InstanceEntity,  Bool)->Void = {viewStore.send(.setInstanceSelected($0, $1))}
            let createRelatedInstance : (SchemaRelationPairElement, SchemaRelationPair, InstanceEntity)->Void = {viewStore.send(.createRelatedInstance($0,$1,$2))}
            let deleteSchemaRelationPair : (SchemaRelationPair)->Void = {viewStore.send(.deleteSchemaRelationPair($0))}
            
            Form{
                
                ForEach(viewStore.schemaEntities){schemaEntity in
                    componentView(viewStore.state.getSubState(of: schemaEntity) as! S)
                        .environment(\.dbrainDataAgent,dBrainDataAgent(
                            schemaEntityFeatureDataAgent: .init(createInstance: createInstance, createRelation: createRelation, deleteSchema: deleteSchema),
                            instanceEntityFeatureDataAgent: .init(deleteInstance: deleteInstance, isSelected: setInstanceSelected),
                            schemaRelationPairElementFeatureDataAgent: .init(createRelatedInstance: createRelatedInstance, delete: deleteSchemaRelationPair)
                        ))
                }
                
            }
                    .toolbar {
                        ToolbarItem {
                            Button {
                                viewStore.send(.createSchema)
                            } label: {
                                Text("+")
                            }
            
                        }
                    }
        }
    }
    
    
     

}
