//
//  SwiftUIView 2.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import SwiftUI

public struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext

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
                    Text(item.name!)
                }

                
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
            .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleInstanceEntity).container.viewContext)
    }
}
