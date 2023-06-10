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
                let instanceElements = viewStore.instanceRelationPairs.map({$0.elements.first(where: {$0.instanceID != viewStore.instanceEntity.id})!})
                Button {
                    viewStore.send(.createRelatedInstance)
                } label: {
                    Text("createInstance")
                }
                ForEach(instanceElements) { instanceElement in
                    Text(instanceElement.instanceID.uuidString)
                }
//                ForEach(viewStore.schemaRelationPairs.flatMap({$0.getPairedElements(of:viewStore.schemaEntity)}), content: { schemaRelationPairElement in
//                    Text(schemaRelationPairElement.id.uuidString)
//                })
            } label: {
                Text(viewStore.schemaRelationPairElement.schemaID.uuidString)
            }
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
