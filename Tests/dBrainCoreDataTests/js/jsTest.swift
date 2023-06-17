//
//  jsTest.swift
//  
//
//  Created by MEI YIN LO on 2023/6/12.
//

import XCTest
import JavaScriptCore

//https://www.appcoda.com/javascriptcore-swift/
//https://stackoverflow.com/questions/37434560/can-i-run-javascript-inside-swift-code
final class jsTest: XCTestCase {

    func testJSFile() throws{
        var jsContext = JSContext()


        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "test", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)

                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                jsContext?.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
     
    func testExample() throws {
        let jsSource = "var testFunct = function(message) { return \"Test Message: \" + message;}"

        var context = JSContext()
        context?.evaluateScript(jsSource)

        let testFunction = context?.objectForKeyedSubscript("testFunct")
        let result = testFunction?.call(withArguments: ["the message"])
        print(testFunction)
        print(result)
    }

     

}
