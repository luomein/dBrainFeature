//
//  jsonTests.swift
//  
//
//  Created by MEI YIN LO on 2023/6/12.
//

import XCTest
import dBrainCoreData

final class jsonTests: XCTestCase {

    struct GroceryProduct: Codable {
        var name: String
        var points: Int
        var description: String?
    }

    func test(){
        let pear = GroceryProduct(name: "Pear", points: 250 )
        
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        
        let data = try! encoder.encode([pear])
        print(String(data: data, encoding: .utf8)!)
    }

    func testNode(){
        let node = InstanceNode(data: .init(id: "fdsf"))
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        
        let data = try! encoder.encode([node]+[node])
        print(String(data: data, encoding: .utf8)!)
    }
}
