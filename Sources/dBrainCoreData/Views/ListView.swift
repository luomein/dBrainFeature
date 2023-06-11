//
//  SwiftUIView 2.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import SwiftUI
import dBrainFeature

public struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dbrainDataAgent) var dataAgent
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<CoreDataSchemaEntity>
    @State var selectItem : SelectItem = .init()
    public init() {
        
    }
    public var body: some View {
        Form{
            Button {
                CoreDataSchemaEntity.createSchema(viewContext: viewContext)
            } label: {
                Text("create")
            }

            ForEach(items, id: \.self) { item in
//                CoreDataIDWrapperView<SchemaEntityView,CoreDataSchemaEntity>(uuid: item.id!
//                                                                                 , componentView: SchemaEntityView.init, selectItem: $selectItem)
                DisclosureGroup {
                    CoreDataSchemaEntityWrapperView(uuid: item.id!)
                } label: {
                    Text(item.name! + " \(item.id!.uuidString)")
                }

                
            }
        }
        .navigationDestination(for: SchemaEntityFeatureView.StackNavPath.self) { destination in
            switch destination{
            case .SchemaEntitySelectToPairFeatureView(let uuid):
                CoreDataSchemaEntitySelectToPairWrapperView(uuid: uuid)
            }
        }
    }
}
struct ListViewWraperView : View{
    @State var navPath = [SchemaEntityFeatureView.StackNavPath]()
    public var body: some View {
        NavigationStack(path: $navPath) {
            ListView()
                
        }
    }
}
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.previewByOption(option: .singleInstanceEntity).container.viewContext
        ListViewWraperView()
        .environment(\.dbrainDataAgent,  viewContext.dataAgent)
            .environment(\.managedObjectContext, viewContext)
    }
}
