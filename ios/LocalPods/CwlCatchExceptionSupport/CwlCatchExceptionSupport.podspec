Pod::Spec.new do |s|
  s.name = 'CwlCatchExceptionSupport'
  s.version = '2.2.1'
  s.summary = 'Objective-C internal library used by CwlCatchException'
  s.homepage = 'https://github.com/mattgallagher/CwlCatchException'
  s.license = { :file => 'LICENSE.txt', :type => 'ISC' }
  s.author = 'Matt Gallagher'
  s.source = { :path => '.' }
  s.source_files = 'Sources/**/*.{m,h}'
  s.public_header_files = 'Sources/Include/*.h'
  s.header_mappings_dir = 'Sources/Include'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  s.visionos.deployment_target = '1.0'
  s.swift_version = '5.5'
end
