//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import ComposableArchitecture

public struct SchemaEntityFeatureView: View {
    var store : StoreOf<SchemaEntityFeature>
    public init(store: StoreOf<SchemaEntityFeature>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DisclosureGroup {
                Button {
                    viewStore.send(.createInstance)
                } label: {
                    Text("createInstance")
                }
                
                ForEach(viewStore.instanceEntities, content: { instance in
                    //Text(instance.id.uuidString)
                    InstanceEntityFeatureView(store: .init(initialState: .init(schemaEntity: viewStore.schemaEntity
                                                                               , instanceEntity: instance
                                                                               , schemaRelationPairs: viewStore.schemaRelationPairs
                                                                               , instanceRelationPairs: viewStore.instanceRelationPairs.filter({$0.hasInstance(instance: instance)})), reducer: InstanceEntityFeature(dataAgent: .init())))
                })
            } label: {
                Text("Instance")
            }
            DisclosureGroup {
                Button {
                    viewStore.send(.createRelation)
                } label: {
                    Text("createRelation")
                }
                
                ForEach(viewStore.schemaRelationPairs.flatMap({$0.getPairedElements(of:viewStore.schemaEntity)}), content: { schemaRelationPairElement in
                    Text(schemaRelationPairElement.id.uuidString)
                })
            } label: {
                Text("Relation")
            }
                 
            
        }
    }
}
struct SchemaEntityFeatureWrapperView: View {
    @State var dataSource = SchemaEntityFeature.State(schemaEntity: .init(id: UUID(), name: "test")
                                                      , instanceEntities: [], schemaRelationPairs: [], instanceRelationPairs: [])
    var body: some View {
        Form{
            SchemaEntityFeatureView(store: .init(initialState: dataSource, reducer: SchemaEntityFeature(dataAgent: .init(createInstance: createInstance, createRelation: createRelation))))
        }
    }
    func createInstance(of schema: SchemaEntity){
        dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
    }
    func createRelation(of schema: SchemaEntity){
        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
        let newSchema = SchemaEntity(id: UUID(), name: "\(Int.random(in: 0...1000))")
        dataSource.schemaRelationPairs.append(.init(id: UUID(), elements: [
            .init(id: UUID(), schemaID: schema.id)
            ,.init(id: UUID(), schemaID: newSchema.id)
        ]))
    }
}
struct SchemaEntityFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        SchemaEntityFeatureWrapperView()
    }
}
