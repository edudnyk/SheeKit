Pod::Spec.new do |s|
  s.name = 'SheeKit'
  s.version = '0.0.2'
  s.license = 'MIT License'
  s.summary = 'A bridge between SwiftUI and UIKit which enriches the modal presentations in SwiftUI with the features available in UIKit.'
  s.homepage = 'https://github.com/edudnyk/SheeKit'
  s.authors = { 'Eugene Dudnyk' => 'edudnyk@gmail.com' }
  s.source = { :git => 'https://github.com/edudnyk/SheeKit.git', :tag => s.version }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/SheeKit/**/*.{h,swift}'
  s.preserve_paths = 'Sources/SheeKit/SheeKit.docc'
  s.swift_version = '5.5'
end
