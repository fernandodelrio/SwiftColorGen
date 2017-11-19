//
//  main.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio on 18/11/17.
//  Copyright © 2017 Fernando del Rio. All rights reserved.
//

import Foundation

func main() {
    guard let args = CLIManager.getArgs(arguments: CommandLine.arguments) else {
        print("Invalid arguments")
        exit(1)
    }
    let storyboards = StoryboardManager.getStoryboards(baseFolder: args.baseFolder)
    var allColors: Set<ColorData> = Set<ColorData>()
    for storyboard in storyboards {
        let result = StoryboardManager.readStoryboard(path: storyboard)
        let xml = StoryboardManager.addResources(xml: result.xml, colors: result.colors)
        allColors = allColors.union(result.colors)
        StoryboardManager.writeStoryboard(xml: xml, path: storyboard)
    }
    StoryboardManager.writeColorAssets(path: args.assetsFolder, colors: allColors)
    StoryboardManager.writeOutputfile(path: args.outputFile, colors: allColors)
}

main()


