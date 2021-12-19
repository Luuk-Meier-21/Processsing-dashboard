//
//  bash.swift
//
//  Created by andreacipriani
//

import Foundation

protocol CommandExecuting {
    static func run(commandName: String, arguments: [String]) throws -> String
}

typealias ProgramRef = String;
extension ProgramRef {
    static let vsCode: ProgramRef = "Visual Studio Code - Insiders";
    static let processing: ProgramRef = "Processing";
    static let fallback: ProgramRef = "TextEdit";
}

struct Bash: CommandExecuting {
    
    enum BashError: Error {
        case commandNotFound(name: String)
    }
    
    static func run(commandName: String, arguments: [String] = []) throws -> String {
        return try run(resolve(commandName), with: arguments)
    }

    static private func resolve(_ command: String) throws -> String {
        guard var bashCommand = try? run("/bin/bash" , with: ["-l", "-c", "which \(command)"]) else {
            throw BashError.commandNotFound(name: command)
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return bashCommand
    }

    static private func run(_ command: String, with arguments: [String] = []) throws -> String {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.launch()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}
