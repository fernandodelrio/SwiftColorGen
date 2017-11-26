//
//  AssetManager.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 24/11/17.
//

import Foundation

class AssetManager {
    // Gets asset data from the Assets folder
    static func getAssetColors(assetsFolder: String) -> [Asset] {
        let assets = getAssets(assetsFolder: assetsFolder)
        var assetColors: [Asset] = []
        assets.forEach { colorset in
            let newAsset = Asset()
            newAsset.color = getAssetColor(colorsetFolder: colorset)
            newAsset.path = colorset
            // It's a new custom color, if there's no swiftcg.json
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: "\(colorset)/swiftcg.json")) else {
                newAsset.originalName = getAssetName(path: colorset)
                newAsset.currentName = newAsset.originalName
                newAsset.type = .customAdded
                assetColors.append(newAsset)
                return
            }
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let json = jsonObject as? [String: Any] else {
                return
            }
            let name = json["name"] as? String ?? ""
            let custom = json["custom"] as? Bool ?? false
            // If the name on the folder is different from the swiftcg.json
            //   it's a renamed color
            if name != getAssetName(path: colorset) {
                newAsset.originalName = name
                newAsset.currentName = getAssetName(path: colorset)
                newAsset.type = .customRenamed
                assetColors.append(newAsset)
                return
            }
            // If custom is marked with false, it's a original generated color
            //   (color generated from storyboard). In this case, we can change
            //   the name
            if !custom {
                newAsset.originalName = name
                newAsset.currentName = name
                newAsset.type = .original
                assetColors.append(newAsset)
                return
            }
            // No condition matched, the color wasn't modified
            newAsset.originalName = name
            newAsset.currentName = name
            newAsset.type = .customUnmodified
            assetColors.append(newAsset)
        }
        return assetColors
    }
    
    // Deletes all colorsets, preparing for a new code generation
    static func deleteColorsets(assets: [Asset]) {
        let original = assets.filter { $0.type == .original }
        original.forEach { try? FileManager.default.removeItem(atPath: $0.path ?? "") }
    }
    
    // Updates swiftcg.json name and set custom to true
    static func updateCustomJson(assets: [Asset]) {
        let customAssets = assets.filter {
            $0.type == .customRenamed ||
            $0.type == .customAdded
        }
        customAssets.forEach { customAsset in
            let colorPath = customAsset.path ?? ""
            let metaData = "{\"name\": \"\(customAsset.currentName ?? "")\", \"custom\": true}"
            let metaDataPath = "\(colorPath)/swiftcg.json"
            try? metaData.write(to: URL(fileURLWithPath: metaDataPath), atomically: false, encoding: .utf8)
        }
    }
    
    // Write all colors to the .xcassets folder
    static func writeColorAssets(path: String, colors: Set<ColorData>) {
        let generatorData = ColorManager.getColorsForGenerator(colors: colors)
        generatorData.forEach { data in
            let colorPath = "\(path)/\(data.assetName).colorset"
            let contentsPath = "\(colorPath)/Contents.json"
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: colorPath), withIntermediateDirectories: false, attributes: nil)
            let contentsData = "{\"info\":{\"version\":1,\"author\":\"xcode\"},\"colors\":[{\"idiom\":\"universal\",\"color\":{\"color-space\":\"srgb\",\"components\":{\"red\":\"\(data.color.red)\",\"alpha\":\"\(data.color.alpha)\",\"blue\":\"\(data.color.blue)\",\"green\":\"\(data.color.green)\"}}}]}"
            try? contentsData.write(to: URL(fileURLWithPath: contentsPath), atomically: false, encoding: .utf8)
            let metaDataPath = "\(colorPath)/swiftcg.json"
            let metaData = "{\"name\": \"\(data.assetName)\", \"custom\": false}"
            try? metaData.write(to: URL(fileURLWithPath: metaDataPath), atomically: false, encoding: .utf8)
        }
    }
    
    // Gets the correct color data (it can be 0.0 to 1.0, 0 to 255 or hex
    private static func getColorDataFromAssets(components: [String: String]) -> ColorData {
        let colorData = ColorData()
        guard let red = components["red"],
            let green = components["green"],
            let blue = components["blue"],
            let alpha = components["alpha"] else {
                return colorData
        }
        if red.contains(".") { // 0.0 to 1.0
            colorData.red = Double(red) ?? 0.0
            colorData.green = Double(green) ?? 0.0
            colorData.blue = Double(blue) ?? 0.0
        } else if red.contains("x") { // 0x00 to 0xFF
            colorData.red = Double(Int(red.suffix(2), radix: 16) ?? 0)/255
            colorData.green = Double(Int(green.suffix(2), radix: 16) ?? 0)/255
            colorData.blue = Double(Int(blue.suffix(2), radix: 16) ?? 0)/255
        } else { // 0 to 255
            colorData.red = (Double(red) ?? 0.0)/255
            colorData.green = (Double(green) ?? 0.0)/255
            colorData.blue = (Double(blue) ?? 0.0)/255
        }
        colorData.alpha = Double(alpha) ?? 0.0
        return colorData
    }
    
    // Gets the asset color using the Content.json values
    private static func getAssetColor(colorsetFolder: String) -> ColorData {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: "\(colorsetFolder)/Contents.json")) else {
            return ColorData()
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let json = jsonObject as? [String: Any] else {
            return ColorData()
        }
        guard let colors = (json["colors"] as? [[String: Any]])?.first else {
            return ColorData()
        }
        guard let color = colors["color"] as? [String: Any] else {
            return ColorData()
        }
        guard let components = color["components"] as? [String: String] else {
            return ColorData()
        }
        let colorData = getColorDataFromAssets(components: components)
        return colorData
    }
    
    // Iterate over the base folder to get the storyboard files
    private static func getAssets(assetsFolder: String) -> [String] {
        var assets: [String] = []
        let enumerator = FileManager.default.enumerator(atPath: assetsFolder)
        while let path = enumerator?.nextObject() as? String {
            if PathManager.isValidColorset(path: path) {
                assets.append("\(assetsFolder)/\(path)")
            }
        }
        return assets
    }
    
    // Gets the asset name, using the colorset folder name
    private static func getAssetName(path: String) -> String {
        let path = path.split(by: "/")
        let end = path.last ?? ""
        return end.replacingOccurrences(of: ".colorset", with: "")
    }
}
