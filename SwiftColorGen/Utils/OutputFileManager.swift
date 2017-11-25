//
//  OutputFileManager.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 24/11/17.
//

import Foundation

class OutputFileManager {
    // Write the UIColor extension output file
    static func writeOutputfile(path: String, colors: Set<ColorData>) {
        let generatorData = ColorManager.getColorsForGenerator(colors: colors)
        var output = "// Don't change. Auto generated file. SwiftColorGen\n"
        output += "import UIKit\n\n"
        output += "extension UIColor {\n"
        generatorData.forEach { data in
            output += "\t/// Color #\(data.color.name)\n"
            if data.outputNeedsPrefix {
                output += "\tclass func gen\(data.outputName)() -> UIColor {\n"
            } else {
                output += "\tclass func \(data.outputName)Color() -> UIColor {\n"
            }
            output += "\t\treturn UIColor(named: \"\(data.assetName)\") ?? UIColor.white\n"
            output += "\t}\n\n"
        }
        output = String(output.prefix(output.count-1))
        output += "}\n"
        try? output.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
}
