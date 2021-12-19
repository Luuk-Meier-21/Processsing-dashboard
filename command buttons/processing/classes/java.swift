//
//  java.swift
//  command buttons
//
//  Created by Luuk Meier on 08/12/2021.
//

import Foundation

typealias ProcessingJava = String;

extension ProcessingJava {
    var br: Self {
        return "\(self)\n";
    }
    
    var label: Self {
        return "\(self)\nGENERATED_CODE:"
    }
    
    func valueProperty<VT>(propType: String, name: String, value: VT) -> Self {
        let string = "\(self)\n\(propType) \(name) = \(value);"
        return string;
    }
    
    func valueProperty(propType: String, name: String, closure: (Self) -> Self) -> Self {
        let value: Self = "";
        let string = "\(self)\n\(propType) \(name) = \(closure(value));"
        return string;
    }
    
    func valueProperty(name: String, closure: (Self) -> Self) -> Self {
        let value: Self = "";
        let string = "\(self)\n\\(name) = \(closure(value));"
        return string;
    }

    func addClass(name: String, content: (Self) -> String) -> Self {
        let properties: Self = "";
        let classString = "class \(name) {\n\(content(properties))\n};"
        let string = "\(self)\(classString)"
        return string;
    }
    
    func getArray(_ arrayName: String) -> ProcessingJava {
        let string = "\(self)json.getJSONArray(\"\(arrayName)\");";
        return string;
    }
    
    func getString(_ name: String) -> ProcessingJava {
        let string = "\(self)json.getString(\"\(name)\");";
        return string;
    }
    
    class GetterType {
        static var string = "String",
                   int = "Int"
    
        static func array(_ type: String) -> String {
            return "[\(type)]";
        }
        static func object(_ type: String) -> String {
            return type;
        }
    }
    
//    func use(type: GetterType, name: String, declarations: Self, closure: (Self) -> Self) -> Self {
//        let value: Self = "";
//        declarations = declarations.
//        return value.valueProperty(name: name) { properties in
//            return closure(properties)
//        }
}


struct JavaFactory {
    var filename = "input-data.json"
    var toURL: URL?;
    var jsonObjectName: String = "json"
    var declarations: ProcessingJava = "";
    var consumers: ProcessingJava = "";
    
    func build() -> String {
        var test = base({
            return consumers
                .label
                .getArray("fields").br
                .getString("test").br
                .valueProperty(propType: "String", name: "test") { value in
                    return value.getString("value")
                }.br
        }) {
            return declarations
        }
        print(test)
        return test;
    }
    // getArray()
    // >    for each mirror.children
    //      >   if getString
    //      >   if getInt
    //      >   if getString
    
    
//    static var declarations: ProcessingJavaDeclarations {
//        var string: ProcessingJavaDeclarations = ""
//        return string
//            .addClass(name: "Test") { properties in
//                return properties
//                    .valueProperty(propType: "string", name: "testa", value: 4)
//                    .valueProperty(propType: "string", name: "testC", value: "test")
//            }
//    }
    
    func base(_ content: () -> ProcessingJava, _ declarations: () -> ProcessingJava) -> String {
        return #"""
            // Add "pRunnerData = ProcessingField()" to setup() to use data!
            \#(declarations())
        
            ProcessingField pRunnerData;
            
            class ProcessingField {
                JSONObject \#(jsonObjectName); = loadJSONObject("\#(filename)");
                public ProcessingField() {
                    if (json == null) {
                        println("JSONObject could not be parsed");
                    } else {
                        \#(content())
                    };
                }
            };
        
            
        """#
    }
}
