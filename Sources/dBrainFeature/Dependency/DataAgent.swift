//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/8.
//

import Foundation
import CoreData
import ComposableArchitecture
import SwiftUI

public struct dBrainDataAgent: EnvironmentKey {
    public static let defaultValue = dBrainDataAgent()
    
    public var schemaEntityFeatureDataAgent : SchemaEntityFeature.DataAgent
    public var instanceEntityFeatureDataAgent : InstanceEntityFeature.DataAgent
    public var schemaRelationPairElementFeatureDataAgent : SchemaRelationPairElementFeature.DataAgent
    public var schemaEntitySelectToPairFeatureDataAgent : SchemaEntitySelectToPairFeature.DataAgent
    
    public init(schemaEntityFeatureDataAgent: SchemaEntityFeature.DataAgent =  .init(createInstance: {_ in }, createRelation: {_ in }, deleteSchema: {_ in })
                , instanceEntityFeatureDataAgent : InstanceEntityFeature.DataAgent = .init(deleteInstance: {_ in})
                ,schemaRelationPairElementFeatureDataAgent : SchemaRelationPairElementFeature.DataAgent = .init(createRelatedInstance: {_,_,_  in}, delete: {_ in })
                ,schemaEntitySelectToPairFeatureDataAgent:SchemaEntitySelectToPairFeature.DataAgent = .init(createRelation: {_,_ in})
    ) {
        self.schemaEntityFeatureDataAgent = schemaEntityFeatureDataAgent
        self.instanceEntityFeatureDataAgent = instanceEntityFeatureDataAgent
        self.schemaRelationPairElementFeatureDataAgent = schemaRelationPairElementFeatureDataAgent
        self.schemaEntitySelectToPairFeatureDataAgent = schemaEntitySelectToPairFeatureDataAgent
    }
    
}
public extension EnvironmentValues {
    var dbrainDataAgent: dBrainDataAgent {
        get { self[dBrainDataAgent.self] }
        set { self[dBrainDataAgent.self] = newValue }
  }
}

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
