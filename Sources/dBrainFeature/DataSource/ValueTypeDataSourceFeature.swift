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

public extension ValueTypeDataSourceFeature{
    func deleteSchemaRelationPair(pair: SchemaRelationPair, dataSource: inout ValueTypeDataSource){
       dataSource.instanceRelationPairs.removeAll {$0.schemaID == pair.id}
       dataSource.schemaRelationPairs.remove(id: pair.id)
   }
    func createRelatedInstance(of schemaRelationPairElement: SchemaRelationPairElement, in pair: SchemaRelationPair, from instance: InstanceEntity, dataSource: inout ValueTypeDataSource){
       let newInstance = InstanceEntity(id: UUID(), schemaID: schemaRelationPairElement.schemaID)
       let newPairInstanceElement = InstanceRelationPairElement(id: UUID(), instanceID: newInstance.id, schemaID: schemaRelationPairElement.id)
       
       let pairedSchemaRelationPairElement = pair.elements.first(where: {$0.id != schemaRelationPairElement.id})!
       let pairedInstanceRelationPairElement = InstanceRelationPairElement(id: UUID(), instanceID: instance.id, schemaID: pairedSchemaRelationPairElement.id)
       
       let newPairInstance = InstanceRelationPair(id: UUID(), elements: .init(uniqueElements: [newPairInstanceElement, pairedInstanceRelationPairElement]), schemaID: pair.id)
       
       dataSource.instanceEntities.append(newInstance)
       dataSource.instanceRelationPairs.append(newPairInstance)
   }
   
   func deleteInstance(of instance: InstanceEntity, dataSource: inout ValueTypeDataSource){
       let instanceRelationPairs = dataSource.instanceRelationPairs.filter{$0.hasInstance(instance: instance)}
       dataSource.instanceRelationPairs.removeAll {instanceRelationPairs.contains($0)}
       dataSource.instanceEntities.remove(instance)
   }
   func setInstanceSelected(of instance: InstanceEntity, isSelected: Bool, dataSource: inout ValueTypeDataSource){
       dataSource.instanceEntities[id: instance.id]!.isSelected = isSelected
   }
}
public struct ValueTypeDataSourceFeature : ReducerProtocol{
    public init(){}
    
    public enum Action: Equatable{
        case createSchema
        case createRelation(SchemaEntity)
        case createRelationPair(SchemaEntity,Set<SchemaEntity>)
        case informSchemaCreated(SchemaEntity)
        //case informSchemaRelationCreated(SchemaRelationPair)
        case informSchemaRelationsCreated([SchemaRelationPair])
        case createInstance(SchemaEntity)
        case deleteSchema(SchemaEntity)
        case setInstanceSelected(InstanceEntity,  Bool)
        case deleteInstance( InstanceEntity)
        case createRelatedInstance(SchemaRelationPairElement, SchemaRelationPair,  InstanceEntity)
        case deleteSchemaRelationPair(SchemaRelationPair)
    }
    
    public var body: some ReducerProtocol<ValueTypeDataSource, Action> {
        Reduce{ state, action in
            switch action{
//            case .informSchemaRelationCreated:
//                break
            case .informSchemaCreated(_):
                break
            case .informSchemaRelationsCreated:
                break
            case .deleteSchemaRelationPair(let pair):
                deleteSchemaRelationPair(pair: pair, dataSource: &state)
            case .createRelatedInstance(let element, let pair, let instance):
                createRelatedInstance(of: element, in: pair, from: instance, dataSource: &state)
            case .deleteInstance(let instance):
                deleteInstance(of: instance, dataSource: &state)
            case .setInstanceSelected(let instance, let isSelected):
                setInstanceSelected(of: instance, isSelected: isSelected, dataSource: &state)
            case .createSchema:
                let newItem : SchemaEntity = .init(id: UUID(), name: "\(Int.random(in: 0...1000))")
                state.schemaEntities.append(newItem)
                return .send(.informSchemaCreated(newItem))
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
            case .createRelationPair(let schema1, let schemaSet):
                var pairs : [SchemaRelationPair] = []
                for schema2 in schemaSet{
                    let newPair : SchemaRelationPair = .init(id: UUID(), elements: [
                        .init(id: UUID(), schemaID: schema1.id)
                        ,.init(id: UUID(), schemaID: schema2.id)
                    ])
                    state.schemaRelationPairs.append(newPair)
                    pairs.append(newPair)
                }
                return .send(.informSchemaRelationsCreated(pairs))
                
            case .createRelation(let schema):
                let newSchema = SchemaEntity(id: UUID(), name: "\(Int.random(in: 0...1000))")
                 state.schemaEntities.append(newSchema)
                let newPair : SchemaRelationPair = .init(id: UUID(), elements: [
                    .init(id: UUID(), schemaID: schema.id)
                    ,.init(id: UUID(), schemaID: newSchema.id)
                ])
                state.schemaRelationPairs.append(newPair)
                return .concatenate(.send(.informSchemaCreated(newSchema)),
                                    .send(.informSchemaRelationsCreated([newPair]))
                )
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
    let store : StoreOf<ValueTypeDataSourceFeature>
    @Environment(\.openWindow) private var openWindow

    var componentView : (S)->T
    public init(componentView : @escaping (S)->T, store: StoreOf<ValueTypeDataSourceFeature>? = nil) {
        self.componentView = componentView
        if let store = store{
            self.store = store
        }
        else{
            self.store = .init(initialState: .init(), reducer: {ValueTypeDataSourceFeature()})
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
            let createRelationPair : (SchemaEntity,Set<SchemaEntity>)->Void = {viewStore.send(.createRelationPair($0, $1))}
            let dataAgent = dBrainDataAgent(
                schemaEntityFeatureDataAgent: .init(createInstance: createInstance, createRelation: createRelation, deleteSchema: deleteSchema),
                instanceEntityFeatureDataAgent: .init(deleteInstance: deleteInstance, isSelected: setInstanceSelected),
                schemaRelationPairElementFeatureDataAgent: .init(createRelatedInstance: createRelatedInstance, delete: deleteSchemaRelationPair),
                schemaEntitySelectToPairFeatureDataAgent : .init(createRelation: createRelationPair)
            )
            Form{
                ForEach(viewStore.schemaEntities){schemaEntity in
                    DisclosureGroup {
                        componentView(viewStore.state.getSubState(of: schemaEntity) as! S)
                            .environment(\.dbrainDataAgent,dataAgent)
                    } label: {
                        HStack{
                            Text(schemaEntity.name)
                            Button {
                                openWindow(value: schemaEntity.id)
                            } label: {
                                Text("open")
                            }
                            .buttonStyle(.plain)

                        }
                    }

                    
                    
                }
            }

            .navigationDestination(for: SchemaEntityFeatureView.StackNavPath.self) { destination in
                switch destination{
                case .SchemaEntitySelectToPairFeatureView(let uuid):
                    let schema = viewStore.schemaEntities[id: uuid]!
                    SchemaEntitySelectToPairFeatureView(store: .init(initialState: viewStore.state.getSubStateForSelectSchemaPair(of: schema), reducer: {SchemaEntitySelectToPairFeature()}))
                        .environment(\.dbrainDataAgent,dataAgent)
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