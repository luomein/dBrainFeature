//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import ComposableArchitecture

struct InstanceEntityFeatureView: View {
    @Environment(\.dbrainDataAgent) var dataAgent
    var store : StoreOf<InstanceEntityFeature>
    public init(store: StoreOf<InstanceEntityFeature>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DisclosureGroup {
                ForEach(viewStore.schemaRelationPairs.flatMap({$0.getPairedElements(of:viewStore.schemaEntity)}), content: { schemaRelationPairElement in
                    //Text(schemaRelationPairElement.id.uuidString)
                    SchemaRelationPairElementFeatureView(store: .init(initialState: viewStore.state.getSubState(of: schemaRelationPairElement), reducer: SchemaRelationPairElementFeature(dataAgent: dataAgent.schemaRelationPairElementFeatureDataAgent)))
                })
            } label: {
                Text(viewStore.instanceEntity.id.uuidString)
            }
        }
    }
}
struct InstanceEntityFeatureWrapperView: View {
    @State var dataSource = InstanceEntityFeature.State(schemaEntity: .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!, name: "test")
                                                        , instanceEntity: .init(id: UUID(), schemaID: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!), schemaRelationPairs: [], instanceRelationPairs: [])
    var body: some View {
        Form{
            InstanceEntityFeatureView(store: .init(initialState: dataSource, reducer: InstanceEntityFeature(dataAgent: .init())))
        }
    }
}
struct InstanceEntityFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceEntityFeatureWrapperView()
    }
}
