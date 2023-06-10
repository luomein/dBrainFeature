//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/8.
//

import Foundation
import CoreData
import ComposableArchitecture

//public protocol DataSource{
//    mutating func createInstance(of schema: SchemaEntity)
//    mutating func createSchema()
//    func getSchemaEntities()->IdentifiedArrayOf<SchemaEntity>
//    func getInstanceEntities(of schema: SchemaEntity)->IdentifiedArrayOf<InstanceEntity>
//}
//public struct SampleDataSource:Equatable,DataSource{
//    public mutating func createSchema() {
//        schemaEntities.append(.init(id: UUID(), name: "\(Int.random(in: 0...1000))"))
//    }
//
//    public func getInstanceEntities(of schema: SchemaEntity) -> IdentifiedCollections.IdentifiedArrayOf<InstanceEntity> {
//        return instanceEntities.filter({$0.schemaID == schema.id})
//    }
//
//    public func getSchemaEntities() -> IdentifiedCollections.IdentifiedArrayOf<SchemaEntity> {
//        return schemaEntities
//    }
//
//    var  schemaEntities : IdentifiedArrayOf<SchemaEntity> = []
//    var instanceEntities : IdentifiedArrayOf<InstanceEntity> = []
//
//    public mutating func createInstance(of schema: SchemaEntity){
//        let newItem = InstanceEntity(id: UUID(), schemaID: schema.id)
//        instanceEntities.append(newItem)
//    }
//}
//public protocol DataAgentProtocol{
//    func createInstance(of schema: SchemaEntity)
//}
//public class DataAgent : DependencyKey, ObservableObject, DataAgentProtocol{
//    public static let liveValue: DataAgent = .init(dataSource: SampleDataSource())
//    public static let testValue: DataAgent = .init(dataSource: SampleDataSource())
//
//    @Published public var dataSource : DataSource
//
//    public init(dataSource: DataSource) {
//        self.dataSource = dataSource
//    }
//
//
//
//    public func filterInstance(criteria: InstanceEntityFilterCriteriaFeature.State, of schema: SchemaEntity)->IdentifiedArrayOf<InstanceEntity>{
//        return []
//    }
//    public func getUnfilteredInstance(of schema: SchemaEntity)->IdentifiedArrayOf<InstanceEntity>{
//        return []
//    }
//    public func createInstance(of schema: SchemaEntity){
//        dataSource.createInstance(of: schema)
//    }
//}
//
//extension DependencyValues{
//    public var dataAgent : DataAgent{
//        get { self[DataAgent.self] }
//        set { self[DataAgent.self] = newValue }
//    }
//}
