# SwiftColorGen
A tool that generate code for Swift projects, designed to improve the maintainability of UIColors.

First it reads all storyboard files to find common **sRGB colors**. Then it creates those colors in a **.xcassets** folder and refer them in the storyboard. Finally it creates a **UIColor extension** allowing to access the same colors programatically.

SwiftColorGen is written in Swift and requires Swift to run. The project uses [AEXML](https://github.com/tadija/AEXML) as a dependency to read and write XML.

### The named colors in the Storyboard
![Storyboard](https://github.com/fernandodelrio/SwiftColorGen/raw/master/Resources/Storyboard.png)

### The colors in the Assets catalog
![Assets Catalog](https://github.com/fernandodelrio/SwiftColorGen/raw/master/Resources/Assets.png)

### The generated Swift file
![Swift file](https://github.com/fernandodelrio/SwiftColorGen/raw/master/Resources/Swift.png)

You can also create your own extensions in a separated file to give a more semantic name to the colors:

```swift
extension UIColor {
    class func defaultTextColor() -> UIColor {
        return .gen000000_255()
    }
}
```

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
2. Improve the CLI: Pass parameters in a more clean way. Accept relative paths
3. Reduce the number of changes in the storyboards
4. Find the closest match name to the RGB color to produce something like **blueColor255** instead of **gen0000FF_255**
5. Test on a larger project to see what will happen
6. Test integrated with Xcode's build phase script
7. Distribute: Homebrew and others
8. Add tests


# Contributing
This project still on a initial stage of development. Feel free to contribute by testing it and reporting bugs. If you want to help developing it, checkout the TODO list. If you made some enhancement, open a pull request.

# License
SwiftColorGen is available under the MIT license. See the LICENSE file for more info.

> Please notice, this tool still under development. It's on a validation phase, where I'll test it integrated with existing iOS projects to see if how useful it is. Feedbacks and better ways to handle things are appreciated.
