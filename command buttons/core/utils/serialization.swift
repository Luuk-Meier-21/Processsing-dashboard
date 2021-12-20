//
//  serialization.swift
//  storing-json
//
//  Created by Luuk Meier on 31/10/2021.
//

import Foundation



class Serialization {
    /// The Serializer class contains all base static methods for saving, loading and decoding data.
    
    static func loadData(
        from url: URL
    ) throws -> Data? {
        let data = try Data(contentsOf: url)
        return data;
    }
    
    static func save(
        data: Data,
        to url: URL
    ) throws -> Void {
        try data.write(
            to: url
        )
    }
    
    static func decode<T: Codable>(from data: Data) throws -> T {
        let decoder = JSONDecoder();
        let object = try decoder.decode(T.self, from: data)
        return object
    }
    
    static func decodeToString(from data: Data) -> String {
        let string = String(decoding: data, as: UTF8.self);
        return string;
    }
}

class JSONCodableSerialization<T: Codable> {
    /// The JSONCodableSerialization uses the JSONDecoder, JSONEncoder and Serializer classes to save and load json data from a given url.
    
    let decoder = JSONDecoder();
    let encoder = JSONEncoder();
    
    init() {
        encoder.outputFormatting = .prettyPrinted;
    }
    
    func loadJSON(from url: URL) throws -> T {
        let data: Data? = try Serialization.loadData(from: url);
        let object: T = try decoder.decode(T.self, from: data!);
        print(object)
        return object;
    }
    
    // save to document filesystem with filename
    func save(jsonObject: T, to url: URL) throws -> Void {
        let data: Data = try encoder.encode(jsonObject);
        try Serialization.save(data: data, to: url);
    }
}

