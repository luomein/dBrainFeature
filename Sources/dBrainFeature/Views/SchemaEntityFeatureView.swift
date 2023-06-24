//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import ComposableArchitecture

public struct SchemaEntityFeatureView: View {
    public enum StackNavPath:Hashable{
        case SchemaEntitySelectToPairFeatureView(UUID)
        case InstanceEntitySelectToPairFeatureView(instanceEntity: UUID
                                                   , schemaRelationPair: UUID
                                                   , schemaRelationPairElement: UUID)
    }
    @Environment(\.dbrainDataAgent) var dataAgent
    var store : StoreOf<SchemaEntityFeature>
    public init(store: StoreOf<SchemaEntityFeature>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group{
                Button {
                    viewStore.send(.delete)
                } label: {
                    Text("delete")
                }
                .buttonStyle(.plain)
                DisclosureGroup {
                    Button {
                        viewStore.send(.createInstance)
                    } label: {
                        Text("createInstance")
                    }
                    .buttonStyle(.plain)
                    ForEach(viewStore.instanceEntities, content: { instance in
                        //Text(instance.id.uuidString)
                        InstanceEntityFeatureView(store: .init(initialState: viewStore.state.getSubState(of: instance)
                                                               , reducer: InstanceEntityFeature(dataAgent: dataAgent.instanceEntityFeatureDataAgent)))
                    })
                } label: {
                    Text("Instance")
                }
                DisclosureGroup {
                    
                    Button {
                        viewStore.send(.createRelation)
                    } label: {
                        Text("create")
                    }
                    .buttonStyle(.plain)
                    NavigationLink(value: StackNavPath.SchemaEntitySelectToPairFeatureView(viewStore.schemaEntity.id)) {
                        Text("select")
                    }
                    .buttonStyle(.plain)
                    ForEach(viewStore.schemaRelationPairs.flatMap({$0.getPairedElements(of:viewStore.schemaEntity)}), content: { schemaRelationPairElement in
                        HStack{
                            Text(schemaRelationPairElement.schemaID.uuidString)
                            //Text(viewStore.state.schemaEntities[id:schemaRelationPairElement.schemaID]!.name)
                        }
                    })
                } label: {
                    Text("Relation")
                }
                
            }
        }
    }
}
public struct SchemaEntityFeatureDataSourceView: View {
//    var localDataAgent: dBrainDataAgent = .init(schemaEntityFeatureDataAgent:  .init(createInstance: createInstance, createRelation: createRelation))
    //@Environment(\.dbrainDataAgent) var dataAgent
    @State var dataSource = SchemaEntityFeature.State(schemaEntity: .init(id: UUID(), name: "test")
                                                      , instanceEntities: [], schemaRelationPairs: [], instanceRelationPairs: [])
    public init(){
    }
    
    public var body: some View {
        SchemaEntityFeatureWrapperView(dataSource: dataSource)
            .environment(\.dbrainDataAgent, dBrainDataAgent(schemaEntityFeatureDataAgent:.init(createInstance: createInstance, createRelation: createRelation, deleteSchema: {_ in})
                                                        , schemaRelationPairElementFeatureDataAgent: .init(createRelatedInstance: createRelatedInstance, delete: deleteSchemaRelationPair)
                                                       ))
       
    }
    func deleteSchemaRelationPair(pair: SchemaRelationPair){
        dataSource.schemaRelationPairs.remove(id: pair.id)
    }
    func createRelatedInstance(of schemaRelationPairElement: SchemaRelationPairElement, in pair: SchemaRelationPair, from instance: InstanceEntity){
        let newInstance = InstanceEntity(id: UUID(), schemaID: schemaRelationPairElement.schemaID)
        let newPairInstanceElement = InstanceRelationPairElement(id: UUID(), instanceID: newInstance.id, schemaID: schemaRelationPairElement.id)
        
        let pairedSchemaRelationPairElement = pair.elements.first(where: {$0.id != schemaRelationPairElement.id})!
        let pairedInstanceRelationPairElement = InstanceRelationPairElement(id: UUID(), instanceID: instance.id, schemaID: pairedSchemaRelationPairElement.id)
        
        let newPairInstance = InstanceRelationPair(id: UUID(), elements: .init(uniqueElements: [newPairInstanceElement, pairedInstanceRelationPairElement]), schemaID: pair.id)
        
        //dataSource.instanceEntities.append(newInstance) it belongs to another schema
        dataSource.instanceRelationPairs.append(newPairInstance)
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
public struct SchemaEntityFeatureWrapperView: View {
//    var localDataAgent: dBrainDataAgent = .init(schemaEntityFeatureDataAgent:  .init(createInstance: createInstance, createRelation: createRelation))
    @Environment(\.dbrainDataAgent) var dataAgent
    var dataSource : SchemaEntityFeature.State
    public init(dataSource: SchemaEntityFeature.State) {
        self.dataSource = dataSource
    }
    public var body: some View {
        Group{
            SchemaEntityFeatureView(store: .init(initialState: dataSource, reducer: SchemaEntityFeature(dataAgent: dataAgent.schemaEntityFeatureDataAgent
                                                                                                       )))
        }
        
        
    }
    
}
struct SchemaEntityFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SchemaEntityFeatureDataSourceView()
        }
    }
}
