//
//  storage.swift
//  storing-json
//
//  Created by Luuk Meier on 26/10/2021.
//

import Foundation

class URLSet {
    var absoluteURL: URL?;
    var path: URL?;
    var filename: String;
    var extention: String;
    
    init(path: URL, filename: String, extention: String) {
        self.path = path;
        self.filename = filename
        self.extention = extention
        resolveAbsolutePath(from: path);
    }
    
    init(filename: String, extention: String) {
        self.filename = filename
        self.extention = extention
    }
    
    static var empty = URLSet(
        filename: "<Empty>",
        extention: "<Empty>"
    )
    
    private func resolveAbsolutePath(from url: URL) {
        self.path = url;
        self.absoluteURL = url
        .appendingPathComponent(filename)
        .appendingPathExtension(extention)
    }
    
    func setAbsoluteURL(from path: URL) {
        resolveAbsolutePath(from: path);
    }
}

class Storage<T: Codable>: ObservableObject {
    var data: T;
    @Published var hasLoaded: Bool;
    var hasSaved: Bool;
    var isUnresolvable: Bool;
    var empty: T;
    var serializer: JSONCodableSerialization<T>;
    
    init(empty: T) {
        self.empty = empty;
        self.data = empty;
        self.hasLoaded = false;
        self.hasSaved = false;
        self.isUnresolvable = false;
        self.serializer = JSONCodableSerialization<T>();
    }
    
//    func updateSavedState(_ old: T, _ new: T) {
//        if old == new {
//            self.hasSaved = false;
//        }
//    }
}

class JSONStorage<T: Codable>: Storage<T> {
    var url: URLSet;
    var defaultDirectory: URL {
        let fm = FileManager.default
        if let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url;
        } else {
            return URL(fileURLWithPath: "")
        }
    }
    
    init(emptyObject empty: T, toPath path: String, toFilename filename: String,  toExtention extention: String = "json") {
        self.url = .empty;
        super.init(empty: empty);
        self.url = URLSet(
            path: defaultDirectory.appendingPathComponent(path),
            filename: filename,
            extention: extention
        );
        
        _ = load();
        print(self)
    }
    
    /// Initializer for use with unknown filename set after initialization:
    init(emptyObject empty: T, toFilename filename: String, toExtention extention: String = "json") {
        self.url = .empty;
        super.init(empty: empty);
        self.url = URLSet(
            filename: filename,
            extention: extention
        );
        print(self)
    }
    
    /// Loads new data and updates "hasLoaded" state
    func load() -> Bool {
        do {
            if url.absoluteURL != nil {
                self.data = try serializer.loadJSON(from: url.absoluteURL!);
                self.hasLoaded = true;
                print("succes: ", data)
                return true;
            } else {
                throw StorageError.absoluteURLIsNil
            }
        } catch {
            print("load failed: ", error)
            self.data = empty;
            self.hasLoaded = false;
            self.isUnresolvable = true;
            return false;
        }
    }
    
    func load(from absoluteURL: URL?) -> Bool {
        do {
            url.setAbsoluteURL(from: absoluteURL!)
            if url.absoluteURL != nil {
                
                self.data = try serializer.loadJSON(from: url.absoluteURL!);
                self.hasLoaded = true;
                return true;
            } else {
                throw StorageError.absoluteURLIsNil
            }
        } catch {
            self.data = empty;
            self.hasLoaded = false;
            self.isUnresolvable = true;
            return false;
        }
    }
    
    func save(object jsonObject: T) -> Bool {
        do {
            if url.absoluteURL != nil {
                _ = try serializer.save(jsonObject: data, to: url.absoluteURL!)
                _ = load();
                return true;
            } else {
                throw StorageError.absoluteURLIsNil
            }
        } catch {
            print("save failed: ", error)
            return false;
        }
    }
    
    enum StorageError: Error {
        case absoluteURLIsNil
    }
}
