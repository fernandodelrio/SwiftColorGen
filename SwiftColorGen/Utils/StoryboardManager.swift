//
//  StoryboardManager.swift
//  SwiftColorGen
//
//  Created by Fernando Del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

struct StoryboardManager {
    // Iterate over the base folder to get the storyboard files
    static func getStoryboards(baseFolder: String) -> [String] {
        var storyboards: [String] = []
        let enumerator = FileManager.default.enumerator(atPath: baseFolder)
        while let path = enumerator?.nextObject() as? String {
            if PathManager.isValidStoryboard(path: path) {
                storyboards.append("\(baseFolder)/\(path)")
            }
        }
        return storyboards
    }
    
    // Update the storyboard setting the named colors on in and
    // returns the updated XML and the colors found
    static func updateStoryboard(path: String) -> (xml: AEXMLDocument, colors: Set<ColorData>) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return (xml: AEXMLDocument(), colors: Set<ColorData>())
        }
        guard let xml = try? AEXMLDocument(xml: data, options: AEXMLOptions()) else {
            return (xml: AEXMLDocument(), colors: Set<ColorData>())
        }
        
        // Here the colors are updated after they're retrieved
        let colors = ColorManager.getColors(xml: xml.root)
        
        return (xml: xml, colors: colors)
    }
    
    // Add the "resources" key to avoid a storyboard warning
    static func addResources(xml: AEXMLDocument, colors: Set<ColorData>) -> AEXMLDocument {
        if xml.root.getChild(name: "resources") == nil {
            xml.root.addChild(name: "resources")
        }
        guard let resources = xml.root.getChild(name: "resources") else {
            return AEXMLDocument()
        }
        colors.forEach { color in
            // Adding only if it's not already there
            if resources.getChild(name: "namedColor",
                                  attributes: ["name": color.name]) == nil {
                let child = resources.addChild(name: "namedColor",
                                               attributes: ["name": color.name])
                child.addChild(name: "color",
                               value: nil,
                               attributes: ["red": String(color.red),
                                            "green": String(color.green),
                                            "blue": String(color.blue),
                                            "alpha": String(color.alpha),
                                            "colorSpace": "custom",
                                            "customColorSpace": "sRGB"])
            }
        }
        return xml
    }
    
    // Write the updated storyboard to file
    static func writeStoryboard(xml: AEXMLDocument, path: String) {
        try? xml.xml.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
    
    // Write all colors to the .xcassets folder
    static func writeColorAssets(path: String, colors: Set<ColorData>) {
        let generatorData = ColorManager.getColorsForGenerator(colors: colors)
        generatorData.forEach { data in
            let colorPath = "\(path)/\(data.assetName).colorset"
            let contentsPath = "\(colorPath)/Contents.json"
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: colorPath), withIntermediateDirectories: false, attributes: nil)
            let data = "{\"info\":{\"version\":1,\"author\":\"xcode\"},\"colors\":[{\"idiom\":\"universal\",\"color\":{\"color-space\":\"srgb\",\"components\":{\"red\":\"\(data.color.red)\",\"alpha\":\"\(data.color.alpha)\",\"blue\":\"\(data.color.blue)\",\"green\":\"\(data.color.green)\"}}}]}"
            try? data.write(to: URL(fileURLWithPath: contentsPath), atomically: false, encoding: .utf8)
        }
    }
    
    // Write the UIColor extension output file
    static func writeOutputfile(path: String, colors: Set<ColorData>) {
        let generatorData = ColorManager.getColorsForGenerator(colors: colors)
        var output = "// Don't change. Auto generated file. SwiftColorGen\n\n"
        output += "extension UIColor {\n"
        generatorData.forEach { data in
            output += "\tclass func \(data.outputName)() -> UIColor {\n"
            output += "\t\treturn UIColor(named: \"\(data.assetName)\") ?? UIColor.white\n"
            output += "\t}\n\n"
        }
        output += "}\n"
        try? output.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
}
