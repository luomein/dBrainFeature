//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import ComposableArchitecture

struct SchemaRelationPairElementFeatureView: View {
    var store : StoreOf<SchemaRelationPairElementFeature>
    public init(store: StoreOf<SchemaRelationPairElementFeature>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DisclosureGroup {
//                let instanceElements = viewStore.instanceRelationPairs.map({$0.elements.first(where: {$0.instanceID != viewStore.instanceEntity.id})!})
                let instanceElements = viewStore.instanceRelationPairs.map({$0.elements.first(where: {$0.schemaID == viewStore.schemaRelationPairElement.id})!})
                Button {
                    viewStore.send(.createRelatedInstance)
                } label: {
                    Text("createInstance")
                }
                .buttonStyle(.plain)
                NavigationLink(value: SchemaEntityFeatureView.StackNavPath.InstanceEntitySelectToPairFeatureView(
                    instanceEntity: viewStore.instanceEntity.id
                    , schemaRelationPair: viewStore.schemaRelationPair.id
                    , schemaRelationPairElement: viewStore.schemaRelationPairElement.id)) {
                                        Text("select")
                                    }
                                    .buttonStyle(.plain)
                Button{
                                    viewStore.send(.delete)
                                }
                            label: {
                                Text("delete")
                            }
                            .buttonStyle(.plain)
                
                ForEach(instanceElements) { instanceElement in
                    Text(instanceElement.instanceID.uuidString)
                }
//                ForEach(viewStore.schemaRelationPairs.flatMap({$0.getPairedElements(of:viewStore.schemaEntity)}), content: { schemaRelationPairElement in
//                    Text(schemaRelationPairElement.id.uuidString)
//                })
            } label: {
                HStack{
                    Text(viewStore.schemaRelationPairElement.schemaID.uuidString)
                    Text(viewStore.schemaRelationPairElement.id.uuidString)
                }
            }
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
