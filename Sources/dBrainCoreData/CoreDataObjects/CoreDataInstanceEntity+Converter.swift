//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//
import Foundation
import dBrainFeature
import CoreData

public extension CoreDataInstanceEntity{
    struct Converter{
        public var instanceEntity : InstanceEntity{
            return .init(id: item.id!, schemaID: item.schemaID)
        }
        
        public typealias T = CoreDataInstanceEntity
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var converter: Converter{
        return .init(item: self)
    }
}
