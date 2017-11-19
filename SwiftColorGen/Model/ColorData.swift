//
//  ColorData.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

// The color data structure, unically identified by
// the RGBA values. The name and safe name are used
// to name the colors inside the .xcassets folder and
// the generated swift file functions
class ColorData: Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    var name: String {
        let redValue = Int(255*Double(red))
        let greenValue = Int(255*Double(green))
        let blueValue = Int(255*Double(blue))
        let alphaValue = Int(255*Double(alpha))
        let hexRed = String(format: "%2X", redValue)
            .replacingOccurrences(of: " ", with: "0")
        let hexGreen = String(format: "%2X", greenValue)
            .replacingOccurrences(of: " ", with: "0")
        let hexBlue = String(format: "%2X", blueValue)
            .replacingOccurrences(of: " ", with: "0")
        return "\(hexRed)\(hexGreen)\(hexBlue)(\(alphaValue))"
    }
    
    var safeName: String {
        return name
                .replacingOccurrences(of: "(", with: "_")
                .replacingOccurrences(of: ")", with: "")
    }

    init() {
        red = 0.0
        green = 0.0
        blue = 0.0
        alpha = 0.0
    }
    
    static func ==(lhs: ColorData, rhs: ColorData) -> Bool {
        return lhs.name == rhs.name
    }
    
    var hashValue: Int {
        return name.hashValue
    }
}
