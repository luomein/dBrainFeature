//
//  SwiftUIView 2.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    //private var items: FetchedResults<CoreDataInstanceEntity>
    private var items: FetchedResults<CoreDataSchemaEntity>
    @State var selectItem : SelectItem = .init()
    
    var body: some View {
        Form{
            ForEach(items, id: \.self) { item in
//                CoreDataIDWrapperView<InstanceEntityView,CoreDataInstanceEntity>(uuid: item.id!
//                                                                                 , componentView: InstanceEntityView.init, selectItem: $selectItem)
                CoreDataIDWrapperView<SchemaEntityView,CoreDataSchemaEntity>(uuid: item.id!
                                                                                 , componentView: SchemaEntityView.init, selectItem: $selectItem)
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
