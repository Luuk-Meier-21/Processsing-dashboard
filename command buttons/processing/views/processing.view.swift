//
//  processing-json.swift
//  command buttons
//
//  Created by Luuk Meier on 09/11/2021.
//

import Foundation
import SwiftUI

struct ProcessingDataView: View {
    @StateObject var settings = JSONStorage<SketchSettings>(
        emptyObject: SketchSettings(),
        toPath: "processing/data",
        toFilename: "settings"
    )
    @StateObject var sketchData = JSONStorage<ProcessingData>(
        emptyObject: ProcessingData(),
        toFilename: "input-data"
    )
    let sketchFolder = SketchFolder();
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Processing runner").font(.headline)
                    Spacer();
                    if sketchData.hasLoaded && sketchData.hasSaved {
                        Label("Up to date", systemImage: "checkmark.circle").foregroundColor(Color.accentColor)
                    } else if sketchData.hasLoaded {
                        Label("Current data not saved", systemImage: "exclamationmark.circle").foregroundColor(Color(NSColor.darkGray))
                    } else {
                        
                    }
                }
//                Button(action: {
//                    saveJavaJsonLoader()
//                }) {
//                    Text("print")
//                }
                Divider();
                dataLoader() {
                    ProcessingFieldView()
                    .environmentObject(settings)
                    .environmentObject(sketchData)
                    .environmentObject(ObservableContainer<GeometryProxy>(geometry))
                }
                Spacer();
                // TODO: Valid URLS is not rly working on all children (bug)
                if settings.data.paths.validURLs {
                    sketchControls
                }
                Divider()
                folderSelector
            }
                .padding()
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
        }
    }
    
    func saveJavaJsonLoader() {
        let factory = JavaFactory();
        let url = settings.data.paths.absolutePath!.appendingPathComponent("test").appendingPathExtension("pde")
        do {
            var data = factory.build().data(using: .ascii);
            try Serialization.save(data: data!, to: url)
        } catch {
            print("Failed to save", error)
        }
    }
     
    func loadData(from path: URL?) -> Bool {
        if path != nil {
            sketchData.url.setAbsoluteURL(from: path!)
            _ = sketchData.load();
            print(sketchData.isUnresolvable)
            return true;
        } else {
            return false;
        }
    }
    
    func runSketch(from launchPath: String) -> Void {
        Queue.execute {
            if let output = try? Bash.run(commandName: "/Library/Scripts/Processing/prun", arguments: [
                "--run",
                "--sketch=\(launchPath)"
            ]) {
                print(output)
            }
        }
    }
    
    @ViewBuilder var sketchControls: some View {
        HStack {
            if sketchData.hasSaved {
                Label("Saved", systemImage: "checkmark.circle")
                    .foregroundColor(Color.accentColor)
            } else {
                Label("Current changes not saved", systemImage: "exclamationmark.circle").opacity(0.25)
            }
            Spacer()
            
            Button(action: {
                sketchData.url.setAbsoluteURL(from: settings.data.paths.dataURL!)
                sketchData.hasSaved = sketchData.save(object: sketchData.data);
            }) {
                Label("Save", systemImage: "square.and.arrow.down")
            }
//                        .disabled(!sketchData.hasLoaded)
        
            
            Button(action: {
                runSketch(from: settings.data.paths.launchURL!.path)
                
            }) {
                Label("Run", systemImage: "play.rectangle")
            }
        }
    }
    
    @ViewBuilder var folderSelector: some View {
        HStack {
            if settings.data.paths.absolutePath != nil {
                Label(#"\#(settings.data.paths.absolutePath!)"#, systemImage: "folder")

            } else {
                Label("No sketch folder selected", systemImage: "questionmark.folder")
            }
            Spacer()
            Button(action: {
                sketchFolder.select() { url in
                    
                    // set pathData.data urls:
                    settings.data.setPath(path: url)
                    // set start directory for folder selector
                    
                    // save pathdata url
                    _ = settings.save(object: settings.data);
                    
                    // Save sketchData to selected patbData
                    sketchData.url.setAbsoluteURL(from: settings.data.paths.dataURL!)
                }
            }) {
                Text("Select sketch folder")
            }
        }
    }
    
    @ViewBuilder func dataLoader<Content: View>(content: @escaping () -> Content) ->  some View {
        if sketchData.hasLoaded {
            content();
        } else {
            if !sketchData.isUnresolvable {
                if loadData(from: settings.data.paths.dataURL) {
                    Text("Loading...")
                }
            } else {
                Text("Unable to load data")
                Button(action: {
                    sketchData.url.setAbsoluteURL(from: settings.data.paths.dataURL!)
                    sketchData.hasSaved = sketchData.save(object: sketchData.data);
                }) {
                    Label("Clear data & fix issue", systemImage: "arrow.clockwise")
                }
            }
            
        }
    }
}
