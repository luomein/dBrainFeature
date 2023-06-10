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
            
                VStack{
                    Button {
                        viewStore.send(.createInstance)
                    } label: {
                        Text("createInstance")
                    }
                    
                    ForEach(viewStore.instanceEntities, content: { instance in
                        Text(instance.id.uuidString)
                    })
                }
            
        }
    }
}
struct SchemaEntityFeatureWrapperView: View {
    @State var dataSource = SchemaEntityFeature.State(schemaEntity: .init(id: UUID(), name: "test")
                                                      , instanceEntities: [], schemaRelationPairs: [], instanceRelationPairs: [])
    var body: some View {
        SchemaEntityFeatureView(store: .init(initialState: dataSource, reducer: SchemaEntityFeature(dataAgent: .init(createInstance: createInstance))))
    }
    func createInstance(of schema: SchemaEntity){
        dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
    }
}
struct SchemaEntityFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        SchemaEntityFeatureWrapperView()
    }
}
