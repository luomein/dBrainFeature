//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/12.
//

import Foundation

public struct InstanceRelationPairEdge: Codable{
    var data: data
    var classes : String?
    
    public init(data: data, classes: String? = nil) {
        self.data = data
        self.classes = classes
    }
    public struct data: Codable{
        var id: String
        var source: String
        var target: String
        public init(id:String,source: String, target: String) {
            self.id = id
            self.source = source
            self.target = target
        }
    }
}
