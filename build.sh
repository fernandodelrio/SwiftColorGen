mkdir -p bin
swiftc \
SwiftColorGen/main.swift \
SwiftColorGen/Libs/AEXML/Document.swift \
SwiftColorGen/Libs/AEXML/Element.swift \
SwiftColorGen/Libs/AEXML/Error.swift \
SwiftColorGen/Libs/AEXML/Options.swift \
SwiftColorGen/Libs/AEXML/Parser.swift \
SwiftColorGen/Libs/CommandLineKit/CommandLine.swift \
SwiftColorGen/Libs/CommandLineKit/Option.swift \
SwiftColorGen/Libs/CommandLineKit/StringExtensions.swift \
SwiftColorGen/Extensions/AEXMLElement.swift \
SwiftColorGen/Model/ColorData.swift \
SwiftColorGen/Model/WebColors.swift \
SwiftColorGen/Model/Asset.swift \
SwiftColorGen/Utils/CLIManager.swift \
SwiftColorGen/Utils/ColorManager.swift \
SwiftColorGen/Utils/PathManager.swift \
SwiftColorGen/Utils/OutputFileManager.swift \
SwiftColorGen/Utils/AssetManager.swift \
SwiftColorGen/Utils/ColorSpaceManager.swift \
SwiftColorGen/Utils/StoryboardManager.swift -o swiftcg
