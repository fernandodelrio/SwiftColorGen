//
//  ColorSpaceManager.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 02/12/17.
//

import Foundation
import AppKit

class ColorSpaceManager {
    // Converts the storyboard colors to sRGB
    static func convertToSRGB(xml: AEXMLElement) {
        guard xml.name == "color" else {
            return
        }
        
        // Custom
        let cocoaTouchSystemColor = xml.attributes["cocoaTouchSystemColor"] ?? ""
        if !cocoaTouchSystemColor.isEmpty {
            convertCustomColor(xml: xml)
        }
        
        let customColorSpace = xml.attributes["customColorSpace"] ?? ""
        let colorSpace = xml.attributes["colorSpace"] ?? ""
        
        // Returns, if already sRGB
        if customColorSpace == "sRGB" {
            return
        }
        
        // Gray scale color spaces
        if colorSpace == "calibratedWhite" {
            convertCalibratedWhite(xml: xml)
        }
        if colorSpace == "deviceWhite" {
            convertDeviceWhite(xml: xml)
        }
        if customColorSpace == "genericGamma22GrayColorSpace" {
            convertGenericGamma22Gray(xml: xml)
        }
        
        // RGB color spaces
        if customColorSpace == "displayP3" {
            convertDisplayP3(xml: xml)
        }
        if customColorSpace == "adobeRGB1998" {
            convertAdobeRGB1998(xml: xml)
        }
        if colorSpace == "deviceRGB" {
            convertDeviceRGB(xml: xml)
        }
        if colorSpace == "calibratedRGB" {
            convertCalibratedRGB(xml: xml)
        }
        
        // CYMK color spaces
        
        if customColorSpace == "genericCMYKColorSpace" {
            convertGenericCMYK(xml: xml)
        }
        if colorSpace == "deviceCMYK" {
            convertDeviceCMYK(xml: xml)
        }
        
        // Catalog
        if colorSpace == "catalog" {
            convertCatalog(xml: xml)
        }
    }
    
    // MARK: Gray scale color spaces
    
    private static func convertCalibratedWhite(xml: AEXMLElement) {
        let white = CGFloat(Double(xml.attributes["white"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(calibratedWhite: white, alpha: alpha)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["white"] = nil
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    private static func convertDeviceWhite(xml: AEXMLElement) {
        let white = CGFloat(Double(xml.attributes["white"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(deviceWhite: white, alpha: alpha)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["white"] = nil
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    private static func convertGenericGamma22Gray(xml: AEXMLElement) {
        let white = CGFloat(Double(xml.attributes["white"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(genericGamma22White: white, alpha: alpha)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["white"] = nil
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    // MARK: RGB color spaces
    
    private static func convertDisplayP3(xml: AEXMLElement) {
        let red = CGFloat(Double(xml.attributes["red"] ?? "") ?? 0.0)
        let green = CGFloat(Double(xml.attributes["green"] ?? "") ?? 0.0)
        let blue = CGFloat(Double(xml.attributes["blue"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        if #available(OSX 10.12, *) {
            guard let color = NSColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
                                .usingColorSpace(.sRGB) else {
                return
            }
            xml.attributes["customColorSpace"] = "sRGB"
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["red"] = "\(color.redComponent)"
            xml.attributes["green"] = "\(color.greenComponent)"
            xml.attributes["blue"] = "\(color.blueComponent)"
            xml.attributes["alpha"] = "\(color.alphaComponent)"
        }
    }
    
    private static func convertAdobeRGB1998(xml: AEXMLElement) {
        let red = CGFloat(Double(xml.attributes["red"] ?? "") ?? 0.0)
        let green = CGFloat(Double(xml.attributes["green"] ?? "") ?? 0.0)
        let blue = CGFloat(Double(xml.attributes["blue"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(colorSpace: .adobeRGB1998, components: [red, green, blue, alpha], count: 4)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    private static func convertDeviceRGB(xml: AEXMLElement) {
        let red = CGFloat(Double(xml.attributes["red"] ?? "") ?? 0.0)
        let green = CGFloat(Double(xml.attributes["green"] ?? "") ?? 0.0)
        let blue = CGFloat(Double(xml.attributes["blue"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(deviceRed: red, green: green, blue: blue, alpha: alpha)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    private static func convertCalibratedRGB(xml: AEXMLElement) {
        let red = CGFloat(Double(xml.attributes["red"] ?? "") ?? 0.0)
        let green = CGFloat(Double(xml.attributes["green"] ?? "") ?? 0.0)
        let blue = CGFloat(Double(xml.attributes["blue"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    // MARK: CYMK color spaces
    
    private static func convertGenericCMYK(xml: AEXMLElement) {
        let cyan = CGFloat(Double(xml.attributes["cyan"] ?? "") ?? 0.0)
        let yellow = CGFloat(Double(xml.attributes["yellow"] ?? "") ?? 0.0)
        let magenta = CGFloat(Double(xml.attributes["magenta"] ?? "") ?? 0.0)
        let black = CGFloat(Double(xml.attributes["black"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(colorSpace: .genericCMYK,
                                  components: [cyan, magenta, yellow, black, alpha], count: 5)
                            .usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    private static func convertDeviceCMYK(xml: AEXMLElement) {
        let cyan = CGFloat(Double(xml.attributes["cyan"] ?? "") ?? 0.0)
        let yellow = CGFloat(Double(xml.attributes["yellow"] ?? "") ?? 0.0)
        let magenta = CGFloat(Double(xml.attributes["magenta"] ?? "") ?? 0.0)
        let black = CGFloat(Double(xml.attributes["black"] ?? "") ?? 0.0)
        let alpha = CGFloat(Double(xml.attributes["alpha"] ?? "") ?? 0.0)
        guard let color = NSColor(deviceCyan: cyan,
                                  magenta: magenta,
                                  yellow: yellow,
                                  black: black,
                                  alpha: alpha).usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    // MARK: Catalog
    private static func convertCatalog(xml: AEXMLElement) {
        let colorList = NSColorList.Name(xml.attributes["catalog"] ?? "")
        let colorName = NSColor.Name(xml.attributes["name"] ?? "")
        guard let catalogColor = NSColor(catalogName: colorList, colorName: colorName),
              let color = catalogColor.usingColorSpace(.sRGB) else {
            return
        }
        xml.attributes["customColorSpace"] = "sRGB"
        xml.attributes["colorSpace"] = "custom"
        xml.attributes["red"] = "\(color.redComponent)"
        xml.attributes["green"] = "\(color.greenComponent)"
        xml.attributes["blue"] = "\(color.blueComponent)"
        xml.attributes["alpha"] = "\(color.alphaComponent)"
    }
    
    // MARK: Custom color
    
    private static func convertCustomColor(xml: AEXMLElement) {
        // Didn't found a better way to do that, so
        //   I'm just returning the value for the colors,
        //   when the color on storyboard has the key
        //   cocoaTouchSystemColor
        let cocoaTouchSystemColor = xml.attributes["cocoaTouchSystemColor"] ?? ""
        if cocoaTouchSystemColor == "darkTextColor" {
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["customColorSpace"] = "genericGamma22GrayColorSpace"
            xml.attributes["white"] = "0.0"
            xml.attributes["alpha"] = "1"
        }
        if cocoaTouchSystemColor == "groupTableViewBackgroundColor" {
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["customColorSpace"] = "sRGB"
            xml.attributes["red"] = "0.93725490199999995"
            xml.attributes["green"] = "0.93725490199999995"
            xml.attributes["blue"] = "0.95686274510000002"
            xml.attributes["alpha"] = "1"
        }
        if cocoaTouchSystemColor == "lightTextColor" {
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["customColorSpace"] = "genericGamma22GrayColorSpace"
            xml.attributes["white"] = "1"
            xml.attributes["alpha"] = "0.59999999999999998"
        }
        if cocoaTouchSystemColor == "scrollViewTexturedBackgroundColor" {
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["customColorSpace"] = "sRGB"
            xml.attributes["red"] = "0.43529411759999997"
            xml.attributes["green"] = "0.4431372549"
            xml.attributes["blue"] = "0.47450980390000003"
            xml.attributes["alpha"] = "1"
        }
        if cocoaTouchSystemColor == "tableCellGroupedBackgroundColor" {
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["customColorSpace"] = "genericGamma22GrayColorSpace"
            xml.attributes["white"] = "1"
            xml.attributes["alpha"] = "1"
        }
        if cocoaTouchSystemColor == "viewFlipsideBackgroundColor" {
            xml.attributes["colorSpace"] = "custom"
            xml.attributes["customColorSpace"] = "sRGB"
            xml.attributes["red"] = "0.1215686275"
            xml.attributes["green"] = "0.12941176469999999"
            xml.attributes["blue"] = "0.14117647059999999"
            xml.attributes["alpha"] = "1"
        }
        xml.attributes["cocoaTouchSystemColor"] = nil
    }
}
