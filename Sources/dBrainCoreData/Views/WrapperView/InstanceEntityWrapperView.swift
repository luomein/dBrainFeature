//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/4.
//

import SwiftUI
import CoreData

struct CoreDataIDWrapperView<ComponentView:View, T:NSManagedObject>: View where T:CoreDataProperty {
    @Environment(\.managedObjectContext) private var viewContext
    //typealias T = CoreDataInstanceEntity
    var requestItems : FetchRequest<T>
    private var items: FetchedResults<T>{requestItems.wrappedValue}
    var componentView : (Binding<SelectItem>)->ComponentView
    @Binding var selectItem : SelectItem
    
    init(uuid: UUID , componentView : @escaping (Binding<SelectItem>)->ComponentView
         , selectItem : Binding<SelectItem>  ){

        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        self.requestItems = .init(fetchRequest: fetchRequest)
        self.componentView = componentView
        //self._selectItem = State(initialValue: selectItem)
        self._selectItem = selectItem
    }
    var body: some View {
        if let item = items.first
           {
            //if T.mutableSetValueKey == "relationPairElements"{SimpleInstanceEntityView(item: item as! CoreDataInstanceEntity)}
            //Text(item.mutableSetValue(forKey:T.mutableSetValueKey).count.description)
//            let selectItem = SelectItem.setValue(setSelectItemByType: item.setSelectItemByType
//                                             , selectItem: selectItem)
            componentView(.constant( SelectItem.setValue(setSelectItemByType: item.setSelectItemByType
                                              , selectItem: selectItem)) )
        }
    }
}

//struct InstanceEntityWrapperView<ComponentView:View>: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    typealias T = CoreDataInstanceEntity
//    var requestItems : FetchRequest<T>
//    private var items: FetchedResults<T>{requestItems.wrappedValue}
//    var componentView : (T)->ComponentView
//
//    init(uuid: UUID , componentView : @escaping (T)->ComponentView){
//
//        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
//        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
//        self.requestItems = .init(fetchRequest: fetchRequest)
//        self.componentView = componentView
//    }
//    var body: some View {
//        if let item = items.first{
//            componentView(item)
//        }
//    }
//}

struct InstanceEntityWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            CoreDataIDWrapperView<InstanceEntityView,CoreDataInstanceEntity>(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
                                                                             , componentView: InstanceEntityView.init, selectItem: .constant(.init()))
        }
        .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleInstanceEntity).container.viewContext)
    }
}
