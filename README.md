# SwiftColorGen
A tool that generate code for Swift projects, designed to improve the maintainability of UIColors

First it reads all storyboard files to find common **sRGB colors**. Then it creates those colors in a **.xcassets** file and refer them in the storyboard. Finally it creates a **UIColor extension** allowing to access the same colors programatically

The user should call the CLI passing:
1. The project's base folder (that contains the storyboard)
2. The .xcassets folder (where the colors will be created)
3. The swift output file (where the UIColor's extension will be
 created)
Obs: Always use absolute paths when passing the arguments. If you pass a relative path, it won't work

There's an example inside the project, so you can test the code generation.

You can call the CLI using the terminal, but you can also call it using Xcode. To do that, just edit the scheme and add **Arguments Passed On Launch**:
```
baseFolder=$SRCROOT/Example
assetsFolder=$SRCROOT/Example/Assets.xcassets
outputFile=$SRCROOT/Example/Generated.swift
```
# TODO
1. Add support to other color spaces than the sRGB
2. Distribute: Homebrew and others
3. Add screenshots to README.md
4. Improve the CLI: Pass parameters in a more clean way. Accept relative paths
5. Add tests

# Contributing
This project still on a initial stage of development. Feel free to contribute by testing it and reporting bugs. If you want to help developing it, checkout the TODO list. If you made some enhancement, open a pull request.

# License
SwiftColorGen is available under the MIT license. See the LICENSE file for more info.
