//
//  ColorManager.swift
//  SwiftColorGen
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 19/11/17.
//  Copyright © 2017 Fernando del Rio. All rights reserved.
//

import Foundation

struct ColorManager {
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
                
                setColor(xml: xml, hex: color.hex)
            }
            for child in xml.children {
                read(xml: child)
            }
        }
        read(xml: xml)
        return colors
    }
    
    private static func setColor(xml: AEXMLElement, hex: String) {
        xml.attributes["red"] = nil
        xml.attributes["green"] = nil
        xml.attributes["blue"] = nil
        xml.attributes["alpha"] = nil
        xml.attributes["colorSpace"] = nil
        xml.attributes["customColorSpace"] = nil
        xml.attributes["name"] = hex
    }
}
