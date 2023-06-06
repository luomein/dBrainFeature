//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/4.
//

import SwiftUI

struct SwiftUIView: View {
    var someText = "testnnnnnn"
    var body: some View {
        Form{
            Group {
                Text(someText)
                DisclosureGroup(content: {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    List{
                        Text("test")
                        Button {
                            
                        } label: {
                            Text("dsflk")
                        }
                        DisclosureGroup(content: {
                            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                            List{
                                Text("test")
                                Button {
                                    
                                } label: {
                                    Text("dsflk")
                                }
                                
                            }
                        }, label: {
                            Text("test")
                        })
                        
                    }
                }, label: {
                    Text("test")
                })
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(someText: "dshfkjsd")
    }
}
