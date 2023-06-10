//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import ComposableArchitecture

struct InstanceEntityFeatureView: View {
    var store : StoreOf<InstanceEntityFeature>
    public init(store: StoreOf<InstanceEntityFeature>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DisclosureGroup {
                ForEach(viewStore.schemaRelationPairs.flatMap({$0.getPairedElements(of:viewStore.schemaEntity)}), content: { schemaRelationPairElement in
                    Text(schemaRelationPairElement.id.uuidString)
                })
            } label: {
                Text("Relation")
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
//    func createRelation(of schema: SchemaEntity){
//        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
//        let newSchema = SchemaEntity(id: UUID(), name: "\(Int.random(in: 0...1000))")
//        dataSource.schemaRelationPairs.append(.init(id: UUID(), elements: [
//            .init(id: UUID(), schemaID: schema.id)
//            ,.init(id: UUID(), schemaID: newSchema.id)
//        ]))
//    }
}
struct InstanceEntityFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceEntityFeatureWrapperView()
    }
}
