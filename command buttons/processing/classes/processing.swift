//
//  processing.swift
//  command buttons
//
//  Created by Luuk Meier on 23/11/2021.
//

import Foundation
import SwiftUI

protocol ProcessingDataFieldChild: Codable {
    var value: QuantumValue { get set };
    var label: String { get set };
    var id: Int { get set };
}


class ProcessingDataField: ProcessingDataFieldChild {
    var label: String;
    var value: QuantumValue;
    var key: String;
    var id: Int;

    required init(value: QuantumValue, label: String, key: String) {
        self.value = value;
        self.label = label;
        self.key = key;
        self.id = 0;
    }
    
    required init(value: QuantumValue, label: String, id: Int, key: String) {
        self.value = value;
        self.label = label;
        self.id = id;
        self.key = key;
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try values.decode(QuantumValue.self, forKey: .value)
        self.label = try values.decode(String.self, forKey: .label)
        self.key = try values.decode(String.self, forKey: .key)
        self.id = try values.decode(Int.self, forKey: .id)
    }
    
    enum CodingKeys: String, CodingKey, Codable {
        case value,
             label,
             id,
             key
    }
}

typealias ProcessingDataFields = [ProcessingDataField];

extension ProcessingDataFields {
//    var length: Int {
//        var length = 0;
//        for _ in self {
//            length += 1;
//        }
//        return length;
//    }
//
    static func orderedInit(_ array: Self) -> Self {
        var orderedArray: Self = [];
        for (index, element) in array.enumerated()  {
            element.id = index;
            orderedArray.append(element);
        }
        return orderedArray;
    }
    
    mutating func orderedAppend(_ element: Self.Element) {
        element.id = self.count;
        self.append(element);
    }
}

class ProcessingData: Codable {
    
    var fields: ProcessingDataFields = .orderedInit([
        ProcessingDataField(value: QuantumValue(.size(Size(500, 200))), label: "Sketch window",     key: "windowSize"),
        ProcessingDataField(value: QuantumValue(.string("ABC")),        label: "Sketch text",       key: "text"),
        ProcessingDataField(value: QuantumValue(.string("")),           label: "Sketch alt text",   key: "textAlt"),
        ProcessingDataField(value: QuantumValue(.int(40)),              label: "Rows",              key: "rows")
        
    ]);
    var test = "This is made in swift";
//    var test1 = QuantumValue(.string("hi there"))
//    var test2 = QuantumValue(.int(43))
//    var test3 = "test";
    
    init() {
//        var test = JavaFactory();
//        test.build()
        var test: String? = "innerValue";
        print(test);
    }
}

class SketchSettings: Codable {
    var paths = Paths();
    var preferredProgram = "Processing";
    
    func setPath(path: URL) {
        paths = Paths(from: path);
    }
    
    class Preferences: Codable {
        
    }
    
    class Paths: Codable {
        var absolutePath: URL?; // Absolute URL to sketch folder, aka root to sketch (/user/document/processing/sketch/)
        var dataURL: URL?;      // Absolute URL to data folder in sketch file (./sketch/data/
        var launchURL: URL?;    // Absolute URL to launch folder, aka sketch folder (./sketch)
        var sketchURL: URL?;    // Absolute URL to sketch file in sketch folder (./sketch/sketch.pde)
        var sketchFile: String?;// Filename of sketch file (sketch.pde)
        var dataDir: String = "data";
        
        init(from path: URL) {
            self.absolutePath = path.deletingLastPathComponent()
            self.dataURL = self.absolutePath!.appendingPathComponent(dataDir)
            self.launchURL = self.absolutePath!
            self.sketchFile = path.lastPathComponent;
            self.sketchURL = self.absolutePath!.appendingPathComponent(self.sketchFile!)
        }
        
        var validURLs: Bool {
            if Mirror(reflecting: self).children.contains(where: {$0 != nil}) {
                return true;
            } else {
                return false;
            }
        }
        
        init() {}
    }

}
