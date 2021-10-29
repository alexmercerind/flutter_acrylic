#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_acrylic.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
	s.name             = 'flutter_acrylic'
	s.version          = '0.1.0'
	s.summary          = 'Flutter library for window acrylic, mica & transparency effects.'
	s.description      = <<-DESC
	Flutter library for window acrylic, mica & transparency effects (Windows, macOS & Linux).
						 DESC
	s.homepage         = 'https://github.com/alexmercerind/flutter_acrylic'
	s.license          = { :file => '../LICENSE' }
	s.author           = { 'Adrian Samoticha' => 'adrian@samoticha.de' }
	s.source           = { :path => '.' }
	s.source_files     = 'Classes/**/*'
	s.dependency 'FlutterMacOS'
  
	s.platform = :osx, '10.11'
	s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
	s.swift_version = '5.0'
  end