//
//  quantumValue.swift
//  command buttons
//
//  Created by Luuk Meier on 25/11/2021.
//  Inspired by Luca Angeletti on Stackoverflow: https://stackoverflow.com/questions/48297263/how-to-use-any-in-codable-type

import Foundation

class QuantumValue: Codable {
    /// Quantum values make it possible to store one value with multiple possible types.
    /// Quantum values are defined by setting the `raw` property which is then “Observed” (unwrapped and assigned) by the `observeValue()` method.

    /// This class is not perfect and could likely be improved by using type inference to get rid of the “Observed” properties.
    
    /// Observed properties:
    var string: String?;
    var int: Int?;
    var size: Size?;
    var stringSelection: Selection<String>?;
    /// Holds raw quantum value:
    var raw: QuantumEnum;
    
    enum QuantumEnum: Codable {
        case int(Int),
             string(String),
             size(Size),
             stringSelection(Selection<String>)
    }
    
    init(_ raw: QuantumEnum) {
        self.raw = raw;
        observeValue();
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self);
        self.raw = try values.decode(QuantumEnum.self, forKey: .raw);
        observeValue();
    }

    func encode(to encoder: Encoder) throws {
        assignValue();
        var container = encoder.container(keyedBy: CodingKeys.self);
        try container.encode(self.raw, forKey: .raw);
        try encodeOptionals(container)
    }
    
    /// The `observeValue()` assigns the underlying value of raw to a property of that type as an optional.
    func observeValue() -> Void {
        switch self.raw {
            case .string(let string):
                self.string = string
            case .int(let int):
                self.int = int
            case .size(let size):
                self.size = size
            case .stringSelection(let stringSelection):
                self.stringSelection = stringSelection
            default:
                print("default")
        }
    }
    
    /// The `assignValue()` assigns the first “observed” value that is not `nil` to the `raw` property as enum of that type.
    func assignValue() -> Void {
        switch self.raw {
            case .string(_):
                if let string = self.string {
                    self.raw = .string(string);
                }
            case .int(_):
                if let int = self.int {
                    self.raw = .int(int);
                }
            case .size(_):
                if let size = self.size {
                    print("size: assign ", size.w)
                    self.raw = .size(size);
                }
            case .stringSelection(_):
                if let stringSelection = self.stringSelection {
                    self.raw = .stringSelection(stringSelection);
                }
            default:
                print("default")
        }
    }
    
    /// The encodeOptionals adds the first “observed” value that is not `nil` to the encoded version of this class. This makes accesses from the JSON file easier.
    func encodeOptionals(_ container: KeyedEncodingContainer<QuantumValue.CodingKeys>) throws -> Void {
        var container = container;
        
        switch self.raw {
            case .string(_):
                if let string = self.string {
                    try container.encode(string, forKey: .string);
                }
            case .int(_):
                if let int = self.int {
                    try container.encode(int, forKey: .int);
                }
            case .size(_):
                if let size = self.size {
                    try container.encode(size, forKey: .size);
                }

            default:
                print("default")
        }
    }
    
    enum CodingKeys: String, CodingKey, Codable {
        case raw,
             string,
             int,
             size
            
    }
    
    enum QuantumError:Error {
       case missingValue
    }
}



//extension QuantumValue {
//    var : QuantumValueReadable {
//        get {
//            switch self {
//            case .string(let string):
//                return string
//            case .int(let number):
//                return "\(number)"
//            }
//        }
//    }
//
//    func test() {
//        print(self.getValue)
//    }
//}
