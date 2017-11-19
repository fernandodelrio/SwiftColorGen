//
//  CLIManager.swift
//  SwiftColorGen
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 19/11/17.
//  Copyright © 2017 Fernando del Rio. All rights reserved.
//

import Foundation

struct CLIManager {
    static func getArgs(arguments: [String]) -> (baseFolder: String, assetsFolder: String, outputFile: String)? {
        guard arguments.count == 4 else {
            return nil
        }
        guard let baseFolder = (arguments.filter { $0.hasPrefix("baseFolder=") }.first),
              let assetsFolder = (arguments.filter { $0.hasPrefix("assetsFolder=") }.first),
              let outputFile = (arguments.filter { $0.hasPrefix("outputFile=") }.first) else {
            return nil
        }
        let result = (baseFolder: getValue(argument: baseFolder),
                      assetsFolder: getValue(argument: assetsFolder),
                      outputFile: getValue(argument: outputFile))
        guard PathManager.isAbsolute(path: result.baseFolder),
              PathManager.isAbsolute(path: result.assetsFolder),
              PathManager.isAbsolute(path: result.outputFile) else {
            return nil
        }
        return result
    }
    
    private static func getValue(argument: String) -> String {
        let values = argument.split(separator: "=")
        guard values.count == 2 else {
            return ""
        }
        let value = String(argument.split(separator: "=")[1])
        if value.hasSuffix("/") {
            return String(value.prefix(value.count-1))
        }
        return value
    }
}
