//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import ComposableArchitecture

struct RegionFeatureView: View{
    var store: StoreOf<RegionalFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            if let schema = viewStore.schemaEntities.first!{
                VStack{
                    Button {
                        viewStore.send(.createInstance(of: schema))
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
}
struct RegionalFeatureContainerView: View {
    //@State var sampleDataSource: SampleDataSource = SampleDataSource()
    @StateObject var dataAgent : DataAgent = .init(dataSource: SampleDataSource())
    var body: some View {
        Form{
            Button {
                dataAgent.dataSource.createSchema()
//                sampleDataSource.schemaEntities.append(.init(id: UUID(), name: "\(Int.random(in: 0...1000))"))
            } label: {
                Text("createSchema")
            }
            ForEach(dataAgent.dataSource.getSchemaEntities()){schema in
                DisclosureGroup {
                    RegionFeatureView.init(store: .init(initialState: .init(schemaEntities: [schema]
                                                                            , instanceEntities: dataAgent.dataSource.getInstanceEntities(of: schema)
                                                                           )
                                                        , reducer: RegionalFeature(dataAgent: dataAgent)
                    ))
                } label: {
                    HStack{
                        Text("\(dataAgent.dataSource.getInstanceEntities(of: schema).count)")
                        Button {
                            dataAgent.dataSource.createInstance(of: schema)
                        } label: {
                            Text("createInstance")
                        }
                        
                    }
                }

                
            }
        }
    }
}

struct RegionalFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        RegionalFeatureContainerView()
    }
}
