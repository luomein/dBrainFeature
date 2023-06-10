//
//  Persistence.swift
//  dBranLab
//
//  Created by MEI YIN LO on 2023/5/26.
//

import CoreData
import ComposableArchitecture


//public struct NSManagedObjectContextDependencyManager : DependencyKey {
//    public var viewContext : NSManagedObjectContext
//    public static let liveValue : NSManagedObjectContextDependencyManager = .init(viewContext: PersistenceController.shared.container.viewContext )
//  //public static let previewValue = PersistenceController.preview
//    public static let testValue : NSManagedObjectContextDependencyManager = .init(viewContext: PersistenceController.preview.container.viewContext )
//}
public struct PersistenceController {
    public static let shared = PersistenceController()

    public enum PreviewOption{
        case singleInstanceEntity
        case singleSchemaEntity
    }
    public static func previewByOption(option: PreviewOption)->PersistenceController{
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        switch option{
        case .singleSchemaEntity:
            let schema = CoreDataSchemaEntity(context: viewContext)
            schema.id = UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
            schema.name = "schema"
        case .singleInstanceEntity:
            let schema = CoreDataSchemaEntity(context: viewContext)
            schema.id = UUID()
            schema.name = "schema"
            let schema2 = CoreDataSchemaEntity(context: viewContext)
            schema2.id = UUID()
            schema2.name = "schema2"
            
            let instance = CoreDataInstanceEntity(context: viewContext)
            instance.id = UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
            instance.schema = schema
            
            let pairSchema = CoreDataSchemaRelationPair(context: viewContext)
            pairSchema.id = UUID()
            
            let pairSchemaElement = CoreDataSchemaRelationPairElement(context: viewContext)
            pairSchemaElement.id = UUID()
            pairSchemaElement.schema = schema
            pairSchemaElement.name = "r1"
            pairSchemaElement.pair = pairSchema
            let pairSchemaElement2 = CoreDataSchemaRelationPairElement(context: viewContext)
            pairSchemaElement2.id = UUID()
            pairSchemaElement2.schema = schema2
            pairSchemaElement2.name = "r2"
            pairSchemaElement2.pair = pairSchema
            
            
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }
    public static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        guard let modelURL = Bundle.module.url(forResource:"dBrainModel", withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }
                
        container = NSPersistentContainer(name: "dBrainModel", managedObjectModel: model)
        //container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
