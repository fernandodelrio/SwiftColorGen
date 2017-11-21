//
//  main.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 18/11/17.
//
// SwiftColorGen is a tool that generate code for Swift projects,
//   designed to improve the maintainability of UIColors.
//
// First it reads all storyboard files to find common sRGB colors.
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
// There's an example inside the project, so you can test the code
//   generation.
// You can call the CLI using the terminal, but you can also call
//   it using Xcode. To do that, just edit the scheme and add
//   'Arguments Passed On Launch':
// baseFolder=$SRCROOT/Example
// assetsFolder=$SRCROOT/Example/Assets.xcassets
// outputFile=$SRCROOT/Example/Generated.swift
//
// Obs: Always use absolute paths when passing the arguments.
//   If you pass a relative path, it won't work
//

import Foundation

func main() {
    guard let args = CLIManager.getArgs(arguments: CommandLine.arguments) else {
        print("Invalid arguments")
        exit(1)
    }
    var allColors: Set<ColorData> = Set<ColorData>()
    // Gets the list of storyboards
    let storyboards = StoryboardManager.getStoryboards(baseFolder: args.baseFolder)
    storyboards.forEach { storyboard in
        // Gets the list of colors
        let colors = StoryboardManager.readStoryboard(path: storyboard)
        // Place all colors in a set to avoid duplicates
        allColors = allColors.union(colors)
    }
    if allColors.isEmpty {
        return
    }
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
    StoryboardManager.writeColorAssets(path: args.assetsFolder, colors: allColors)
    // Wirte the generated UIColor extension to file
    StoryboardManager.writeOutputfile(path: args.outputFile, colors: allColors)
}

main()
