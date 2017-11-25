//
//  Asset.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 24/11/17.
//

import Foundation

enum AssetType {
    case original
    case customRenamed
    case customAdded
    case customUnmodified
}

class Asset {
    var originalName: String?
    var currentName: String?
    var path: String?
    var type: AssetType?
    var color: ColorData?
}
