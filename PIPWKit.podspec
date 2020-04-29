#
# Be sure to run `pod lib lint PIP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PIPWKit'
  s.version          = '0.1.0'
  s.summary          = 'Picture in Picture Window for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Picture in Picture to UIWindow

- Device orientation
- iOS11+ with iOS13 modal style support
- Swift 5.x
- XCode 11.5
- Over modal context
                       DESC

  s.homepage         = 'https://github.com/nexor-it/PIPWKit'
  s.documentation_url       = 'https://github.com/nexor-it/PIPWKit/blob/master/README.md'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daniele@nexor.it' => 'daniele@nexor.it' }
  s.source           = { :git => 'https://github.com/nexor-it/PIPWKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'

  # s.resource_bundles = {
  #   'PIP' => ['PIPKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
