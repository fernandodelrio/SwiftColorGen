//
//  ColorManager.swift
//  SwiftColorGen
//
//  Created by Fernando Del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

struct ColorManager {
    // Get a set of sRGB colors from the storyboard
    static func getColors(xml: AEXMLElement) -> Set<ColorData> {
        var colors: Set<ColorData> = Set<ColorData>()
        func read(xml: AEXMLElement) {
            if xml.name == "color",
                let colorSpace = xml.attributes["customColorSpace"],
                colorSpace == "sRGB",
                let red = xml.attributes["red"],
                let green = xml.attributes["green"],
                let blue = xml.attributes["blue"],
                let alpha = xml.attributes["alpha"] {
                let color = ColorData()
                color.red = Double(red) ?? 0.0
                color.green = Double(green) ?? 0.0
                color.blue = Double(blue) ?? 0.0
                color.alpha = Double(alpha) ?? 0.0
                colors.insert(color)
            }
            if xml.name != "namedColor" {
                for child in xml.children {
                    read(xml: child)
                }
            }
        }
        read(xml: xml)
        return colors
    }
    
    static func updateColors(xml: AEXMLElement, colors: Set<ColorData>) {
        let generatorData = getColorsForGenerator(colors: colors)
        func read(xml: AEXMLElement) {
            if xml.name == "color",
                let colorSpace = xml.attributes["customColorSpace"],
                colorSpace == "sRGB",
                let red = xml.attributes["red"],
                let green = xml.attributes["green"],
                let blue = xml.attributes["blue"],
                let alpha = xml.attributes["alpha"] {
                let color = ColorData()
                color.red = Double(red) ?? 0.0
                color.green = Double(green) ?? 0.0
                color.blue = Double(blue) ?? 0.0
                color.alpha = Double(alpha) ?? 0.0
                if let data = (generatorData.filter { $0.color == color }.first) {
                    setColor(xml: xml, name: data.assetName)
                }
            }
            for child in xml.children {
                read(xml: child)
            }
        }
        read(xml: xml)
    }
    
    // Update the storyboard color from a raw value
    // to a named color
    private static func setColor(xml: AEXMLElement, name: String) {
        xml.attributes["red"] = nil
        xml.attributes["green"] = nil
        xml.attributes["blue"] = nil
        xml.attributes["alpha"] = nil
        xml.attributes["colorSpace"] = nil
        xml.attributes["customColorSpace"] = nil
        xml.attributes["name"] = name
    }
    
    static func getClosestColorName(colorData: ColorData) -> (assetName: String, outputName: String)? {
        guard let webColors = getWebColors() else {
            return nil
        }
        let initial = (name: "", distance: Double.greatestFiniteMagnitude)
        let name = webColors
                    .map { (name: $0.name,
                            distance: getColorDistance(from: colorData,
                                                       to: $0.colorData))
                    }
                    .reduce(initial) { $0.distance < $1.distance ? $0 : $1 }
                    .name
        if colorData.alpha < 1.0 {
            return (assetName: name + " (alpha \(Int(255*Double(colorData.alpha))))",
                    outputName: name + "Alpha\(Int(255*Double(colorData.alpha)))")
        } else {
            return (assetName: name, outputName: name)
        }
    }
    
    static func getWebColors() -> [(name: String, colorData: ColorData)]? {
        guard let data = WebColor.values.data(using: .utf8) else {
            return nil
        }
        guard let array = try? JSONSerialization.jsonObject(with: data, options: []),
            let colors = array as? [[String:Any]] else {
            return nil
        }
        return colors.map { color in
            let rgb = color["rgb"] as? Dictionary<String, Double> ?? [:]
            let name = color["name"] as? String ?? ""
            let r = rgb["r"] ?? 0
            let g = rgb["g"] ?? 0
            let b = rgb["b"] ?? 0
            let colorData = ColorData()
            colorData.red = r/255
            colorData.green = g/255
            colorData.blue = b/255
            return (name:name, colorData: colorData)
        }
    }
    
    static func getColorDistance(from color1: ColorData, to color2: ColorData) -> Double {
        let rDistance = fabs(color1.red - color2.red)
        let gDistance = fabs(color1.green - color2.green)
        let bDistance = fabs(color1.blue - color2.blue)
        return rDistance + gDistance + bDistance
    }
    
    static func getColorsForGenerator(colors: Set<ColorData>) -> [(color: ColorData,
                                                                   assetName: String,
                                                                   outputName: String,
                                                                   outputNeedsPrefix: Bool)] {
        let colors = Array(colors)
        var names: [String] = []
        var result: [(color: ColorData,
                      assetName: String,
                      outputName: String,
                      outputNeedsPrefix: Bool)] = []
        colors.forEach { color in
            guard let closestData = getClosestColorName(colorData: color) else {
                return
            }
            if names.contains(closestData.outputName) {
                result.append((color: color,
                               assetName: color.assetName,
                               outputName: color.outputName,
                               outputNeedsPrefix: true))
            } else {
                result.append((color: color,
                               assetName: closestData.assetName,
                               outputName: closestData.outputName,
                               outputNeedsPrefix: false))
            }
            names.append(closestData.outputName)
        }
        return result
    }
}
