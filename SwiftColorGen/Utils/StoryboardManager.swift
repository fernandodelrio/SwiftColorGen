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
    
    // Reads the storyboard and returns a XML document
    static func readStoryboard(path: String) -> AEXMLDocument {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return AEXMLDocument()
        }
        guard let xml = try? AEXMLDocument(xml: data, options: AEXMLOptions()) else {
            return AEXMLDocument()
        }
        return xml
    }
    
    // Read the storyboard returning the colors found
    static func readStoryboardColors(path: String) -> Set<ColorData> {
        let xml = readStoryboard(path: path)
        return ColorManager.getColors(xml: xml.root)
    }
    
    // Update the storyboard colors and return the updated XML
    static func updateStoryboard(path: String, colors: Set<ColorData>) -> AEXMLDocument {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return AEXMLDocument()
        }
        guard let xml = try? AEXMLDocument(xml: data, options: AEXMLOptions()) else {
            return AEXMLDocument()
        }
        ColorManager.updateColors(xml: xml.root, colors: colors)
        return xml
    }
    
    // Add the "resources" key to avoid a storyboard warning
    static func addResources(xml: AEXMLDocument, colors: Set<ColorData>) {
        let generatorData = ColorManager.getColorsForGenerator(colors: colors)
        if xml.root.getChild(name: "resources") == nil {
            xml.root.addChild(name: "resources")
        }
        guard let resources = xml.root.getChild(name: "resources") else {
            return
        }
        colors.forEach { color in
            // Adding only if it's not already there
            if resources.getChild(name: "namedColor",
                                  attributes: ["name": color.name]) == nil {
                guard let data = (generatorData.filter { $0.color == color }.first) else {
                    return
                }
                let child = resources.addChild(name: "namedColor",
                                               attributes: ["name": data.assetName])
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
    }
    
    // Remove the "resources" storyboard key, preparing for a new code generation
    static func removeOriginalResources(xml: AEXMLDocument, assets: [Asset]) {
        guard let resources = xml.root.getChild(name: "resources") else {
            return
        }
        let original = assets.filter { $0.type == .original }
        let valid = resources.children.filter { child in
            guard child.name == "namedColor" else {
                return false
            }
            let name = child.attributes["name"] ?? ""
            return original.filter { $0.currentName == name }.count == 0
        }
        resources.children = valid
    }
    
    // Updating the resources, for custom colors
    static func updateCustomResources(xml: AEXMLDocument, assets: [Asset]) {
        guard let resources = xml.root.getChild(name: "resources") else {
            return
        }
        let renamed = assets.filter { $0.type == .customRenamed }
        let added = assets.filter { $0.type == .customAdded }
        resources.children.forEach { child in
            guard child.name == "namedColor" else {
                return
            }
            let name = child.attributes["name"] ?? ""
            var customAsset: Asset?
            // Renamed custom color, search for the original name
            if let renamedAsset = (renamed.filter { $0.originalName == name }).first {
                child.attributes["name"] = renamedAsset.currentName
                customAsset = renamedAsset
            }
            // Added custom color, search for the current name
            if let addedAsset = (added.filter { $0.currentName == name }).first {
                customAsset = addedAsset
            }
            guard let asset = customAsset else {
                return
            }
            guard let color = child.children.first, color.name == "color" else {
                return
            }
            ColorSpaceManager.convertToSRGB(xml: color)
            guard color.attributes["colorSpace"] == "custom",
                color.attributes["customColorSpace"] == "sRGB" else {
                    return
            }
            color.attributes["red"] = String(asset.color?.red ?? 0.0)
            color.attributes["green"] = String(asset.color?.green ?? 0.0)
            color.attributes["blue"] = String(asset.color?.blue ?? 0.0)
            color.attributes["alpha"] = String(asset.color?.alpha ?? 0.0)
        }
    }
    
    // Remove the named colors from storyboard, placing the colors there
    //   again, preparing for a new code generation
    static func resetColors(xml: AEXMLDocument, assets: [Asset]) {
        ColorManager.resetColors(xml: xml.root, assets: assets)
    }
    
    // Write the updated storyboard to file
    static func writeStoryboard(xml: AEXMLDocument, path: String) {
        try? xml.xml.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
    }
}
