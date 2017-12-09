//
//  main.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 18/11/17.
//
// SwiftColorGen is a tool that generate code for Swift projects,
//   designed to improve the maintainability of UIColors.
//
// First it reads all storyboard files to find common colors.
// Then it creates those colors in a .xcassets file and refer
//   them in the storyboard
// Finally it creates a UIColor extension allowing to access the
//   same colors programatically
//
// The user should call the CLI passing:
// 1. The project's base folder (that contains the storyboard)
// 2. The .xcassets folder (where the colors will be created)
// 3. The swift output file (where the UIColor's extension will be
//   created)
//
//

import Foundation
import SwiftColorGenLibrary

func main() {
    let args = CLIManager.getArgs()
    let assets = AssetManager.getAssetColors(assetsFolder: args.assetsFolder)
    cleanColors(args: args, assets: assets)
    let oldColors = assets
        .filter { $0.type == .original }
        .map { $0.color ?? ColorData() }
    let newColors = getNewColors(args: args)
    let allColors = newColors.union(oldColors)
    if !allColors.isEmpty {
        writeAllColors(allColors, args: args)
    }
    let customAssets = assets.filter { $0.type != .original }
    // Wirte the generated UIColor extension to file
    OutputFileManager.writeOutputfile(path: args.outputFile,
                                      colors: allColors,
                                      assets: customAssets)
}

func getNewColors(args: (baseFolder: String, assetsFolder: String, outputFile: String)) -> Set<ColorData> {
    // Gets the list of storyboards
    let storyboards = StoryboardManager.getStoryboards(baseFolder: args.baseFolder)
    var allColors: Set<ColorData> = Set<ColorData>()
    storyboards.forEach { storyboard in
        // Gets the list of colors
        let colors = StoryboardManager.readStoryboardColors(path: storyboard)
        // Place all colors in a set to avoid duplicates
        allColors = allColors.union(colors)
    }
    return allColors
}

func writeAllColors(_ allColors: Set<ColorData>,
                    args: (baseFolder: String, assetsFolder: String, outputFile: String)) {
    // Gets the list of storyboards
    let storyboards = StoryboardManager.getStoryboards(baseFolder: args.baseFolder)
    storyboards.forEach { storyboard in
        // Updates the storyboard, settings the colors
        let xml = StoryboardManager.updateStoryboard(path: storyboard,
                                                     colors: allColors)
        // Adds the "resources" key to the storyboard, to
        // avoid a storyboard warning
        StoryboardManager.addResources(xml: xml, colors: allColors)
        // Write the modified XML to file
        StoryboardManager.writeStoryboard(xml: xml, path: storyboard)
    }
    // Write the colors to the .xcassets folder
    AssetManager.writeColorAssets(path: args.assetsFolder, colors: allColors)
}

func cleanColors(args: (baseFolder: String, assetsFolder: String, outputFile: String), assets: [Asset]) {
    let storyboards = StoryboardManager.getStoryboards(baseFolder: args.baseFolder)
    storyboards.forEach { storyboard in
        let xml = StoryboardManager.readStoryboard(path: storyboard)
        StoryboardManager.removeOriginalResources(xml: xml, assets: assets)
        StoryboardManager.updateCustomResources(xml: xml, assets: assets)
        StoryboardManager.resetColors(xml: xml, assets: assets)
        StoryboardManager.writeStoryboard(xml: xml, path: storyboard)
        AssetManager.deleteColorsets(assets: assets)
        AssetManager.updateCustomJson(assets: assets)
    }
}

main()


