#
# Be sure to run `pod lib lint CPAPIService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CPAPIService'
  s.version          = '0.1.4'
  s.summary          = 'CPAPIService is a wrapper library helps us easily manage multiple services based on Alamofire'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CPAPIService is a wrapper library helps us easily manage multiple services based on Alamofire. It contains some base interfaces to handle API.
                       DESC

  s.homepage         = 'https://github.com/althurzard/CPAPIService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'althurzard' => 'nguyen_quocvuong@hotmail.com' }
  s.source           = { :git => 'https://github.com/althurzard/CPAPIService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CPAPIService/Classes/*.{h,m,swift}'
  s.swift_versions = '4.2'
  # s.resource_bundles = {
  #   'CPAPIService' => ['CPAPIService/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.8.0'
end
