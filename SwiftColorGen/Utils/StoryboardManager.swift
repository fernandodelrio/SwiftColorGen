//
//  StoryboardManager.swift
//  SwiftColorGen
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 19/11/17.
//  Copyright © 2017 Fernando del Rio. All rights reserved.
//

import Foundation

struct StoryboardManager {
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
    
    static func readStoryboard(path: String) -> (xml: AEXMLDocument, colors: Set<ColorData>) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return (xml: AEXMLDocument(), colors: Set<ColorData>())
        }
        guard let xml = try? AEXMLDocument(xml: data, options: AEXMLOptions()) else {
            return (xml: AEXMLDocument(), colors: Set<ColorData>())
        }
        
        let colors = ColorManager.getColors(xml: xml.root)
        
        return (xml: xml, colors: colors)
    }
    
    static func addResources(xml: AEXMLDocument, colors: Set<ColorData>) -> AEXMLDocument {
        if xml.root.getChild(name: "resources") == nil {
            xml.root.addChild(name: "resources")
        }
        guard let resources = xml.root.getChild(name: "resources") else {
            return AEXMLDocument()
        }
        for color in colors {
            if resources.getChild(name: "namedColor",
                                  attributes: ["name": color.hex]) == nil {
                let child = resources.addChild(name: "namedColor",
                                               value: nil,
                                               attributes: ["name": color.hex])
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
    
    static func writeStoryboard(xml: AEXMLDocument, path: String) {
        try? xml.xml.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
    
    static func writeColorAssets(path: String, colors: Set<ColorData>) {
        for color in colors {
            let colorPath = "\(path)/\(color.hex).colorset"
            let contentsPath = "\(colorPath)/Contents.json"
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: colorPath), withIntermediateDirectories: false, attributes: nil)
            let data = "{\"info\":{\"version\":1,\"author\":\"xcode\"},\"colors\":[{\"idiom\":\"universal\",\"color\":{\"color-space\":\"srgb\",\"components\":{\"red\":\"\(color.red)\",\"alpha\":\"\(color.alpha)\",\"blue\":\"\(color.blue)\",\"green\":\"\(color.green)\"}}}]}"
            try? data.write(to: URL(fileURLWithPath: contentsPath), atomically: false, encoding: .utf8)
        }
    }
    
    static func writeOutputfile(path: String, colors: Set<ColorData>) {
        var output = "extension UIColor {\n"
        for color in colors {
            output += "\tclass func gen\(color.hex)() -> UIColor {\n"
            output += "\t\treturn UIColor(named: \"\(color.hex)\") ?? UIColor.white\n"
            output += "\t}\n\n"
        }
        output += "}\n"
        try? output.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
}
