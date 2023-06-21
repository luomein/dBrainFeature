//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/20.
//

import Foundation
import SwiftUI
import IdentifiedCollections
import ComposableArchitecture

public struct ValueTypeDataSourceView: View {
    let store : StoreOf<ValueTypeDataSourceFeature>
    @Environment(\.openWindow) private var openWindow


    public init(store: StoreOf<ValueTypeDataSourceFeature>? = nil) {
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
            Group{
                ForEach(viewStore.schemaEntities, id: \.id){schemaEntity in
                    DisclosureGroup {
                        SchemaEntityFeatureWrapperView(dataSource: viewStore.state.getSubState(of: schemaEntity) )
                            .environment(\.dbrainDataAgent,dataAgent)

                    } label: {
                        HStack{
                            Text(schemaEntity.name)
                            Button {
                                openWindow(value: schemaEntity.id)
                            } label: {
                                Text("open...")
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
