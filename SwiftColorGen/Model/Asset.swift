//
//  Asset.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 24/11/17.
//

import Foundation

enum AssetType {
    case original // Generated from storyboard
    case customRenamed // User renamed a color in the Assets folder
    case customAdded // User added a color in the Assets folder
    case customUnmodified // Asset didn't changed since last run
}

// Data structure for the Asset in the Assets folder
class Asset {
    var originalName: String?
    var currentName: String?
    var path: String?
    var type: AssetType?
    var color: ColorData?
}
