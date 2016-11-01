Pod::Spec.new do |s|
  s.name         = "Unilib"
  s.version      = "0.1.1"
  s.summary      = "Generic Swift library of protocols/components for Swift application development. (Non-UI.)"
  s.homepage     = "https://github.com/davidbjames/Unilib"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "David James" => "davidbjames1@gmail.com" }

  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/davidbjames/Unilib.git", :tag => s.version }
  s.source_files = "Unilib/Sources/**/*.{swift}"

  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.framework = "Foundation"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency "RxSwift", "~> 3.0.0"
  s.dependency "RxCocoa", "~> 3.0.0"
  s.dependency "RxSwiftExt", "~> 2.0.0"

end