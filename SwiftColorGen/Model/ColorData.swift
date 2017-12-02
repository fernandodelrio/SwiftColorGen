//
//  ColorData.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

// The color data structure, unically identified by
// the RGBA values. The assetName and the outputName
// are used to name the colors inside the .xcassets
// folder and the generated swift file functions
class ColorData: Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    var name: String {
        let redValue = Int(round(255*red))
        let greenValue = Int(round(255*green))
        let blueValue = Int(round(255*blue))
        let alphaValue = Int(round(255*alpha))
        let hexRed = String(format: "%2X", redValue)
            .replacingOccurrences(of: " ", with: "0")
        let hexGreen = String(format: "%2X", greenValue)
            .replacingOccurrences(of: " ", with: "0")
        let hexBlue = String(format: "%2X", blueValue)
            .replacingOccurrences(of: " ", with: "0")
        return "\(hexRed)\(hexGreen)\(hexBlue) (alpha \(alphaValue))"
    }
    
    var assetName: String {
        let alphaValue = Int(round(255*alpha))
        if alpha == 1.0 {
            return name.replacingOccurrences(of: " (\(alphaValue) )", with: "")
        } else {
            return name
        }
    }
    
    var outputName: String {
        let alphaValue = Int(round(255*alpha))
        if alpha == 1.0 {
            return name.replacingOccurrences(of: " (alpha \(alphaValue))", with: "")
        } else {
            return name.replacingOccurrences(of: " (alpha \(alphaValue))", with: "Alpha\(alphaValue)")
        }
    }

    init() {
        red = 0.0
        green = 0.0
        blue = 0.0
        alpha = 0.0
    }
    
    static func ==(lhs: ColorData, rhs: ColorData) -> Bool {
        return fabs(lhs.red-rhs.red) < 1e-4 &&
               fabs(lhs.green-rhs.green) < 1e-4 &&
               fabs(lhs.blue-rhs.blue) < 1e-4 &&
               fabs(lhs.alpha-rhs.alpha) < 1e-4
    }
    
    var hashValue: Int {
        return (red+blue+green+alpha).hashValue
    }
}
