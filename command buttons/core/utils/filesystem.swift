//
//  folderPicker.swift
//  command buttons
//
//  Created by Luuk Meier on 18/11/2021.
//

import Foundation
import SwiftUI

extension NSOpenPanel {
    /// Extention of `NSOpenPanel` with static presets for getting different types of urls from the filesystem.
    
    static var selectSketchPanel: NSOpenPanel {
        let panel = NSOpenPanel();
        panel.title = "Pick a processing sketch folder";
        panel.showsResizeIndicator = true;
        panel.showsHiddenFiles = false;
        panel.allowsMultipleSelection = false;
        panel.canChooseFiles = true;
        panel.canChooseDirectories = false;
        panel.allowedFileTypes = ["pde"]
        return panel
    }
    static var selectProgram: NSOpenPanel {
        let panel = NSOpenPanel();
        panel.title = "Select a text editor program";
        panel.directoryURL = URL(fileURLWithPath: "/Applications");
        panel.showsResizeIndicator = true;
        panel.showsHiddenFiles = false;
        panel.allowsMultipleSelection = false;
        panel.canChooseFiles = true;
        panel.canChooseDirectories = false;
        panel.allowedFileTypes = ["app"]
        return panel
    }
}

class SketchFolder: Folder {
    /// The Sketchfolder class has methods to get, assign and use a sketch folder url.

    private var url: URL?;
    
    enum SketchFolderError: Error {
        case sketchPathIsNil;
    }
    
    public func select() {
        Folder.selectFolder(from: .selectSketchPanel) { result in
            url = result;
        }
    }
    
    public func select(onValidPath: (_ url: URL) -> Void) {
        Folder.selectFolder(from: .selectSketchPanel) { result in
            url = result;
            onValidPath(result);
        }
    }
    
    public func usePath(onValidPath: (_ url: URL) -> Void) {
        if url != nil {
            onValidPath(url!);
        } else {
            print(SketchFolderError.sketchPathIsNil)
            return
        }
    }
}

class Folder {
    /// The Folder class and its static method `selectFolder()` give the option to open a panel and pass the result on the `onResult` closure.
    
    static func selectFolder(from panel: NSOpenPanel, onResult: ( _ result: URL) -> Void) {
        if (panel.runModal() == NSApplication.ModalResponse.OK) {
            let result = panel.url

            if (result != nil) {
                onResult(result!);
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    enum FolderError: Error {
        case noMatchFound(text: String);
    }
}
