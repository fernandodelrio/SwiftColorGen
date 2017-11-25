//
//  AssetManager.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 24/11/17.
//

import Foundation

class AssetManager {
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
    
    private static func getAssetName(path: String) -> String {
        let path = path.split(by: "/")
        let end = path.last ?? ""
        return end.replacingOccurrences(of: ".colorset", with: "")
    }
    
    static func getAssetColors(assetsFolder: String) -> [Asset] {
        let assets = getAssets(assetsFolder: assetsFolder)
        var assetColors: [Asset] = []
        assets.forEach { colorset in
            let newAsset = Asset()
            newAsset.color = getAssetColor(colorsetFolder: colorset)
            newAsset.path = colorset
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
            
            if name != getAssetName(path: colorset) {
                newAsset.originalName = name
                newAsset.currentName = getAssetName(path: colorset)
                newAsset.type = .customRenamed
                assetColors.append(newAsset)
                return
            }
            if !custom {
                newAsset.originalName = name
                newAsset.currentName = name
                newAsset.type = .original
                assetColors.append(newAsset)
                return
            }
            newAsset.originalName = name
            newAsset.currentName = name
            newAsset.type = .customUnmodified
            assetColors.append(newAsset)
        }
        return assetColors
    }
    
    private static func getAssetColor(colorsetFolder: String) -> ColorData {
        let colorData = ColorData()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: "\(colorsetFolder)/Contents.json")) else {
            return colorData
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let json = jsonObject as? [String: Any] else {
            return colorData
        }
        guard let colors = (json["colors"] as? [[String: Any]])?.first else {
            return colorData
        }
        guard let color = colors["color"] as? [String: Any] else {
            return colorData
        }
        guard let components = color["components"] as? [String: String] else {
            return colorData
        }
        colorData.red = Double(components["red"] ?? "") ?? 0.0
        colorData.green = Double(components["green"] ?? "") ?? 0.0
        colorData.blue = Double(components["blue"] ?? "") ?? 0.0
        colorData.alpha = Double(components["alpha"] ?? "") ?? 0.0
        return colorData
    }
    
    static func deleteColorsets(assets: [Asset]) {
        let original = assets.filter { $0.type == .original }
        original.forEach { try? FileManager.default.removeItem(atPath: $0.path ?? "") }
    }
    
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
}
