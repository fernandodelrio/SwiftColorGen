Pod::Spec.new do |s|
  s.name         = "SwiftColorGen"
  s.version      = "0.5.0"
  s.summary      = "A tool that generate code for Swift projects, designed to improve the maintainability of UIColors"
  s.description  = <<-DESC
                A tool that generate code for Swift projects, designed to improve the maintainability of UIColors.
                SwiftColorGen reads all storyboard files to find common colors.
                Then it creates those colors in a .xcassets folder and refer them in the storyboard.
                Finally it creates a UIColor extension allowing to access the same colors programatically.
                   DESC
  s.homepage     = "https://github.com/fernandodelrio/SwiftColorGen"
  s.screenshots  = "https://raw.githubusercontent.com/fernandodelrio/SwiftColorGen/master/Resources/Storyboard0.3.0.png", "https://raw.githubusercontent.com/fernandodelrio/SwiftColorGen/master/Resources/Assets0.3.0.png", "https://raw.githubusercontent.com/fernandodelrio/SwiftColorGen/master/Resources/Swift0.3.0.png"
  s.license      = {:type => "MIT", :file => "LICENSE.md"}
  s.author       = { "Fernando del Rio" => "fernandomdr@gmail.com" }
  s.social_media_url = "https://twitter.com/fernandohdelrio"
  s.ios.deployment_target = "8.0"
  s.source = { :http => "https://github.com/fernandodelrio/SwiftColorGen/releases/download/#{s.version}/swiftcg-#{s.version}.zip" }
  s.preserve_paths = "swiftcg"
end
