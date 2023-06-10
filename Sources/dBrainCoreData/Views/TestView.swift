//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/3.
//

import SwiftUI
import CoreData


@available(macOS 11.0, *)
struct TestView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<CoreDataInstanceEntity>

    @State var selectItem : Item? = nil
    
    @ViewBuilder
    func getRelatedInstance(pairElement: CoreDataSchemaRelationPairElement
                            ,item: CoreDataInstanceEntity
    )-> some View{
        if let instances = pairElement.coreDataInstanceRelationPairElements?
                                        .filter({
                                            $0.getPairedElement().instance! == item
                                        })

        {
            ForEach(instances ) { instance in
                Text(instance.id?.uuidString ?? "")
            }
        }
        
    }
    
    var body: some View {
        //List(items, id: \.self, selection: $selectItem) {item in
        //if let item = items.first{
        Form{
            ForEach(items, id: \.self) { item in
                Text(item.id?.uuidString ?? "")
                if let pairElements = item.schema!.relationPairElements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}) //item.getRelationPairElement(schemaEntity: item.schema!)
                 {
                    ForEach(pairElements, id: \.self) { pairElement in
                        DisclosureGroup {
                            //Text(pairElement.pair!.id?.uuidString ?? "")
                            getRelatedInstance(pairElement: pairElement, item: item)
                        } label: {
                            HStack{
                                Text(pairElement.name ?? pairElement.schema!.name! )
                                Button {
                                    item.createRelatedInstance(schemaRelationPairElement: pairElement, viewContext: viewContext)
                                } label: {
                                    Text("create")
                                }

                            }
                        }

                    }
                    
                }
            }
        }
    }
}

@available(macOS 11.0, *)
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        //TestView()
        Group{
            DisclosureGroup {
                List{
                    Text("4324")
                    Text("4324")
                }
            } label: {
                Text("4324")
            }
            DisclosureGroup {
                List{
                    Text("4324")
                    Text("4324")
                }
            } label: {
                Text("4324")
            }
        }
            .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleInstanceEntity).container.viewContext)
    }
}
