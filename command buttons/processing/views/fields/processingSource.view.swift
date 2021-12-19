//
//  processingSource.view.swift
//  command buttons
//
//  Created by Luuk Meier on 23/11/2021.
//

import Foundation
import SwiftUI

struct ProcessingSourceView: View {
    @EnvironmentObject var settings: JSONStorage<SketchSettings>;
    
    var body: some View {
        HStack{
//            FieldLabelView(label: label)
            Button(action: {
//                sketchData.url.setAbsoluteURL(from: settings.data.paths.dataURL!)
                editSketch(sketchURL: settings.data.paths.sketchURL!, with: settings.data.preferredProgram)
            }) {
                Label("Edit in IDE", systemImage: "square.and.pencil")
            }
            Button(action: {
//                sketchData.url.setAbsoluteURL(from: settings.data.paths.dataURL!)
                editSketch(sketchURL: settings.data.paths.absolutePath!, with: "Finder")
            }) {
                Text("Open folder with Finder")
            }
        }
    }
    
    func editSketch(sketchURL: URL, with program: String) -> Void {
        Queue.execute {
            do {
                _ = try Bash.run(commandName: "open", arguments: [
                    "-a",
                    "\(program)",
                    "\(sketchURL.path)"
                ])
            } catch {
                print(error)
            }
        }
    }
}

struct SelectAppView: View {
    @EnvironmentObject var settings: JSONStorage<SketchSettings>;
    @Binding var value: String;
    var selectPanel: NSOpenPanel;
    
    var body: some View {
        HStack {
//            FieldLabelView(label: label)
            Text(value).opacity(0.5)
            Button(action: {
                Folder.selectFolder(from: .selectProgram) { result in
                    value = result.deletingPathExtension().lastPathComponent;
                    settings.save(object: settings.data)
                }
            }) {
                Image(systemName: "magnifyingglass")
            }
                .background(Color.clear)
                .mask(Circle())
                .frame(maxWidth: 15)
        }
    }
}
