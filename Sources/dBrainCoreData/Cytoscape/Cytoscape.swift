//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/12.
//

import Foundation

public struct Cytoscape: Codable{
    public var data: data
    public var classes : String?
    
    public init(data: data, classes: String? = nil) {
        self.data = data
        self.classes = classes
    }
    public init(instanceNode: InstanceNode){
        self.data = .init(id: instanceNode.data.id)
        self.classes = instanceNode.classes
    }
    public init(instanceRelationPairEdge: InstanceRelationPairEdge){
        self.data = .init(id: instanceRelationPairEdge.data.id,
                          source: instanceRelationPairEdge.data.source,
                          target: instanceRelationPairEdge.data.target)
        self.classes = instanceRelationPairEdge.classes
    }
    public struct data : Codable{
        public var id: String
        public var source: String?
        public var target: String?
        public init(id: String, source: String? = nil, target: String? = nil) {
            self.id = id
            self.source = source
            self.target = target
        }
    }
    
    
}
