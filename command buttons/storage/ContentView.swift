//
//  ContentView.swift
//  storing-json
//
//  Created by Luuk Meier on 26/10/2021.
//

import SwiftUI

struct TestStruct: Codable {
    var array: [String];
}

struct ContentView: View {
    @StateObject var itemList = JSONStorage<TestStruct>(
        toFilename: "test",
        emptyObject: TestStruct(array: [])
    );
    
    var test = Shell();
    
    var body: some View {
        VStack {
//            if itemList.hasLoaded {
//                ForEach(Array(itemList.data.array.enumerated()), id: \.offset) { index, item in
//                    Text(item);
//                }
//            } else {
//                Text("no items yet");
//            }
            
            Button(action: {
                do {
                    let data: Data? = "Test String".data(using: .utf8);
                    _ = try Serialization.save(data: data!, toFilename: "shell-test", toExtention: "sh")
                } catch {
                    print("failed: ", error)
                }
            }) {
                Text("Save")
            }
            
            Button(action: {
                test.runSketch();
//                Shell.shell(Sketch.runArgs);
            }) {
                Text("run")
            }
            
            Button(action: {
                Shell.test();
//                Shell.shell(Sketch.runArgs);
            }) {
                Text("run shell")
            }
            
            Button(action: {
                itemList.data.array.append("new_\(itemList.data.array.count)");
                _ = itemList.save(object: itemList.data)
                print("button: ", itemList.data)
            }) {
                Text("Button")
            }.padding()
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
