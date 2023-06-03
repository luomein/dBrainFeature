import XCTest
@testable import dBrainFeature
import ComposableArchitecture


final class dBrainFeatureTests: XCTestCase {
    func getTestStore(initState:  dBrainFeature.State
    )->TestStore<dBrainFeature.State,dBrainFeature.Action,dBrainFeature.State,dBrainFeature.Action,()>{
        let reducer = dBrainFeature()
        let uuid = UUID()
        let testStore : TestStore = withDependencies {
            $0.uuid = .incrementing
        } operation: {
            TestStore(initialState: initState
                      , reducer: reducer )
        }
        return testStore
    }
    func getTestInitState()->dBrainFeature.State{
        let parent = UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
        let child = UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!
        
        let schemaParent : SchemaEntity = .init(id: UUID(), name: "parent")
        let schemaChild : SchemaEntity = .init(id: UUID(), name: "child")
        let instanceParent: InstanceEntity = .init(id: parent, schemaID: schemaParent.id)
        let instanceChild: InstanceEntity = .init(id: child, schemaID: schemaChild.id)
        //let schemaRelationPair : SchemaRelationPair
        let schemaRelationPairElementParent : SchemaRelationPairElement = .init(id: parent, schemaID: schemaParent.id)
        let schemaRelationPairElementChild : SchemaRelationPairElement = .init(id: child, schemaID: schemaChild.id)
        let schemaRelationPair : SchemaRelationPair = .init(id: UUID()
                                                            , elements: .init(uniqueElements: [
                                                                schemaRelationPairElementParent
                                                                ,schemaRelationPairElementChild
                                                            ]))
        let instanceRelationPair : InstanceRelationPair = .init(id: UUID()
                                                                , elements: .init(uniqueElements: [
                                                                    .init(id: parent, instanceID: instanceParent.id
                                                                          , schemaID: schemaRelationPairElementParent.id)
                                                                    ,.init(id: child, instanceID: instanceChild.id
                                                                           , schemaID: schemaRelationPairElementChild.id)
                                                                ]), schemaID: schemaRelationPair.id)
        return .init(schemas: .init(uniqueElements: [schemaParent,schemaChild])
                     , schemaRelationPairs: .init(uniqueElements: [schemaRelationPair])
                     , entities: .init(uniqueElements: [instanceParent,instanceChild])
                     , relationPairs: .init(uniqueElements: [instanceRelationPair])
                     , filteredEntities: [])
    }
    
    @MainActor
    func testFilterEntity()async throws{
        
        let initState = getTestInitState()
        let testStore = getTestStore(initState: initState)
        let parent = UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
        let child = UUID(uuidString: "00000000-0000-0000-0000-000000000001" )!
        
        let childRelationPairElement = initState.relationPairs.first!.elements[id: child]!
        
        
        await testStore.send(.filterInstanceRelationElements(.ofEntity(initState.entities[id: parent]!))){
            $0.filteredInstanceRelationElements = .init(uniqueElements: [childRelationPairElement])
        }
        await testStore.receive(.checkConsistency)
        
        let schemaRelationPairElement = testStore.state.schemaRelationPairs.reduce(into: [SchemaRelationPairElement](), { partialResult, schemaRelationPair in
            if let schemaRelationPairElement = schemaRelationPair.elements[id:testStore.state.filteredInstanceRelationElements.first!.schemaID]{
                partialResult.append(schemaRelationPairElement)
            }
        }).first!
        
        await testStore.send(.filterSchemaRelationElements(.ofEntity(initState.entities[id: parent]!))){
            $0.filteredSchemaRelationElements = .init(uniqueElements:
                [schemaRelationPairElement]
                //testStore.state.filteredInstanceRelationElements.first!.schema
             )
        }
        await testStore.receive(.checkConsistency)
        await testStore.send(.filterEntities(.ofEntityRelation(initState.entities[id: parent]!
                                                               , schemaRelationPairElement))){
            $0.filteredEntities = .init(uniqueElements: [initState.entities[id: child]!])
        }
        await testStore.receive(.checkConsistency)
//        let parentRelation = initState.schemaRelationPairs.filter {
//            $0 == initState.entities[id: parent]!.schema
//        }
//        testStore.send(.filterEntities(.ofEntityRelation(initState.entities[id: parent]
//                                                         , initState.schemaRelationPairs.)))
    }
}
