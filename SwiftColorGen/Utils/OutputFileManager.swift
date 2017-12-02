//
//  OutputFileManager.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 24/11/17.
//

import Foundation

class OutputFileManager {
    // Write the UIColor extension output file
    static func writeOutputfile(path: String, colors: Set<ColorData>, assets: [Asset]) {
        let generatorData = ColorManager.getColorsForGenerator(colors: colors)
        var output = "// Don't change. Auto generated file. SwiftColorGen\n"
        output += "import UIKit\n\n"
        output += "extension UIColor {\n"
        // Write the regular colors
        generatorData.forEach { data in
            output += "\t/// Color #\(data.color.name)\n"
            if data.outputNeedsPrefix {
                output += "\tclass func gen\(data.outputName)() -> UIColor {\n"
            } else {
                output += "\tclass func \(data.outputName)Color() -> UIColor {\n"
            }
            output += "\t\treturn UIColor(named: \"\(data.assetName)\") ?? .clear\n"
            output += "\t}\n\n"
        }
        // Write the custom colors
        assets.forEach { asset in
            let name = getCustomColorOutputname(name: asset.currentName ?? "")
            output += "\t/// Color #\(asset.color?.name ?? "")\n"
            output += "\tclass func \(name)() -> UIColor {\n"
            output += "\t\treturn UIColor(named: \"\(asset.currentName ?? "")\") ?? .clear\n"
            output += "\t}\n\n"
        }
        output = String(output.prefix(output.count-1))
        output += "}\n"
        try? output.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
    
    // Get a valid name for a function, based on the custom color name
    private static func getCustomColorOutputname(name: String) -> String {
        let letters = CharacterSet.letters
        guard let first = name.first else {
            return ""
        }
        let range = String(first).rangeOfCharacter(from: letters)
        if range != nil { // Begins with letter
            return String(first).lowercased() + name.dropFirst()
        } else {
            return "gen" + String(first).uppercased() + name.dropFirst()
        }
    }
}
