# SwiftColorGen
A tool that generate code for Swift projects, designed to improve the maintainability of UIColors. 

Please notice, this tool still under development. It's on a validation phase, where I'll test it integrated with existing iOS projects to see how useful it is. Feedbacks are appreciated.
Also notice this tool not only generates new code, but also updates existing storyboard files, so **keep your code under versioning control to avoid any data loss!**

# Table of contents
* [Motivation](#motivation)
* [The solution](#solution)
* [Demo](#demo)
* [Using the CLI](#cli)
* [Installation (CocoaPods)](#installation)
* [Contributing](#contributing)
* [License](#license)

# <a id="motivation"></a> Motivation

Manage colors in iOS projects can be challenging. It would be useful to reuse colors in different places in the storyboard and also access them programmatically. In code, you can group the colors in one place, but it's common to have the same color redefined in many places in the storyboards. When you need to update a color, you need to remember to replace them everywhere and because of that, it becomes hard to maintain.

Since Xcode 9, we are able to define a color asset in the Assets catalog, allowing us to reuse a color inside the storyboards and access them programmatically. Though, this still isn't perfect:
1. To access the colors programmatically, we use a string with the Asset name. If we rename the Asset, we need to remember to replace the strings referring the old asset
2. If we rename an Asset, we also need to manually replace the references to them in the storyboards
3. In an existing project with no color assets defined, we need to group all the colors in the storyboards, manually create the asset colors and replace them everywhere.
# <a id="solution"></a> The solution

**SwiftColorGen** reads all storyboard files to find common colors, it creates them in a **.xcassets** folder (without any duplications) and refer them back in the storyboard. Then, it creates an **UIColor extension** allowing to access the same colors programmatically. It automatically puts a name to the colors found. The name will be the closest webcolor name, measuring the color distance between them. But, the user still can rename the colors and it will keep the storyboards updated.

The rules for naming the colors dinamically:
- The closest web color name (https://en.wikipedia.org/wiki/Web_colors) is considered to name the color
- If the alpha value is less than 255, an "alpha suffix" will be appended to the color name, to avoid name collision
- If two RGB's are close to the same web color, the name still will be used if they have different alphas
- If two RGB's are close to the same web color and they also have the same alpha, the hex of the RGB will be used to avoid name collision

SwiftColorGen is written in Swift and requires Swift to run. The project uses [AEXML](https://github.com/tadija/AEXML) as a dependency to read and write XML and [CommandLine](https://github.com/jatoben/CommandLine) to provide the CLI interface.

# <a id="demo"></a> Demo
That's the result of the code generation:

### Collecting the colors on Storyboard and generating the Assets
![Collecting Colors](https://github.com/fernandodelrio/SwiftColorGen/blob/master/Resources/Gif-Collecting-Colors0.5.0.gif)

### Generating the Swift file
![Swift File](https://github.com/fernandodelrio/SwiftColorGen/blob/master/Resources/Gif-Swift0.5.0.gif)

### Automatic renaming
![Automatic Renaming](https://github.com/fernandodelrio/SwiftColorGen/blob/master/Resources/Gif-Renaming0.5.0.gif)

### Custom colors + multiple replace
![Custom Colors](https://github.com/fernandodelrio/SwiftColorGen/blob/master/Resources/Gif-Custom-Color0.5.0.gif)

Here a complete video with the tool in action:

[![Demo](https://raw.githubusercontent.com/fernandodelrio/SwiftColorGen/master/Resources/Video-thumbnail0.4.0.png)](https://vimeo.com/244528270)

# <a id="cli"></a> Using the CLI
First, call the **build.sh** script (it will produce the **swiftcg** binary in the same folder):
```shell
$ chmod +x build.sh
$ ./build.sh
```

Then call the binary passing with the appropriate parameters:

```shell
Usage: ./swiftcg [options]
-o --outputFile (required):
    Path to the output Swift file
-b --baseFolder (optional):
    Path to the folder where the storyboards are located. Defaults to the current working directory
-a --assetsFolder (optional):
    Path to the assets folder. Defaults to the first .xcassets found under the base folder
 ```
 
Example:
```shell
$ ./swiftcg -o Example/Generated.swift
```

**Notice that OS X 10.12 is required to run, because of a dependency from a NSColor method (used to convert between different color spaces)**

To test with the Example provided, call the **test.sh** script (it will update the files inside the Example folder):
```shell
$ chmod +x test.sh
$ ./test.sh
```

# <a id="installation"></a> Installation
You can install the tool using CocoaPods and then add a **Build Phase** step, that runs SwiftColorGen every time the project is built.

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

1. To integrate SwiftColorGen into your Xcode project, specify it in your Podfile:
```ruby
pod 'SwiftColorGen'
```
2. Install the dependencies:

```shell
$ pod install
```
3. In Xcode: Click on your project in the file list, choose your target under TARGETS, click the **Build Phases** tab and add a **New Run Script Phase** by clicking the little plus icon in the top left. Drag the **New Run Script Phase** above the **Compile Sources phase** and below **Check Pods Manifest.lock**, expand it and then call the tool with something like that:
```shell
"$PODS_ROOT/SwiftColorGen/swiftcg" -b "$SRCROOT" -o "$SRCROOT/CustomColors.swift"
```
4. Build your project and it's done. Remember to add the generated Swift file to Xcode, if it's not already there.

# TODO
1. Reduce the number of changes in the storyboards
2. Test on a larger project to see what will happen
3. Add tests

# <a id="contributing"></a> Contributing
This project still on a initial stage of development. Feel free to contribute by testing it and reporting bugs. If you want to help developing it, checkout the TODO list. If you made some enhancement, open a pull request.

# <a id="license"></a> License
SwiftColorGen is available under the MIT license. See the LICENSE file for more info.
