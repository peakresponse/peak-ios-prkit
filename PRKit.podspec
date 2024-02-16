#
# Be sure to run `pod lib lint PRKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PRKit'
  s.version          = '1.0.0'
  s.summary          = 'PRKit is the custom iOS UI toolkit/library for the Peak Response mobile app.'
  s.description      = <<-DESC
PRKit is the custom iOS UI toolkit/library for the Peak Response mobile app.
                       DESC

  s.homepage         = 'https://github.com/peakresponse/peak-ios-prkit'
  s.license          = { :type => 'LGPL', :file => 'LICENSE.md' }
  s.author           = { 'Francis Li' => 'mail@francisli.com' }
  s.source           = { :git => 'https://github.com/peakresponse/peak-ios-prkit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.5'

  s.source_files = 'PRKit/Classes/**/*'

  s.resources = ['PRKit/Assets/**/*.xcassets', 'PRKit/Assets/**/*.svg']

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AlignedCollectionViewFlowLayout'
  s.dependency 'SVGKit', '~> 3.0'
  s.dependency 'Keyboardy', '~> 0.2'
  s.dependency 'SwiftSignatureView', '~> 3.2.0'

  s.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS[sdk=iphonesimulator*]' => '$(inherited) $FRAMEWORK_SEARCH_PATHS' }
end
