# SwiftColorGen
A tool that generate code for Swift projects, designed to improve the maintainability of UIColors. 

Please notice, this tool still under development. It's on a validation phase, where I'll test it integrated with existing iOS projects to see how useful it is. Feedbacks are appreciated.

**SwiftColorGen** reads all storyboard files to find common **sRGB colors**. Then it creates those colors in a **.xcassets** folder and refer them in the storyboard. Finally it creates a **UIColor extension** allowing to access the same colors programatically.

The rules for naming the colors dinamically:
- The closest web color name (https://en.wikipedia.org/wiki/Web_colors) is considered to name the color
- If the alpha value is less than 255, an "alpha suffix" will be appended to the color name, to avoid name collision
- If two RGB's are close to the same web color, the hex of the RGB will be used to avoid name collision

SwiftColorGen is written in Swift and requires Swift to run. The project uses [AEXML](https://github.com/tadija/AEXML) as a dependency to read and write XML.

### The generated named colors in the Storyboard
![Storyboard](https://github.com/fernandodelrio/SwiftColorGen/raw/master/Resources/Storyboard.png)

### The generated colors in the Assets catalog
![Assets Catalog](https://github.com/fernandodelrio/SwiftColorGen/raw/master/Resources/Assets.png)

### The generated Swift file
![Swift file](https://github.com/fernandodelrio/SwiftColorGen/raw/master/Resources/Swift.png)

You can also create your own extensions in a separated file to give a more semantic name to the colors:

```swift
extension UIColor {
    class func defaultTextColor() -> UIColor {
        return .genDeepPink()
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
4. Test on a larger project to see what will happen
5. Test integrated with Xcode's build phase script
6. Distribute: Homebrew and others
7. Add tests


# Contributing
This project still on a initial stage of development. Feel free to contribute by testing it and reporting bugs. If you want to help developing it, checkout the TODO list. If you made some enhancement, open a pull request.

# License
SwiftColorGen is available under the MIT license. See the LICENSE file for more info.
