#
# Be sure to run `pod lib lint PRKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PRKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PRKit.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/peakresponse/peak-ios-prkit'
  s.license          = { :type => 'LGPL', :file => 'LICENSE.md' }
  s.author           = { 'Francis Li' => 'mail@francisli.com' }
  s.source           = { :git => 'https://github.com/peakresponse/peak-ios-prkit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.4'

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
