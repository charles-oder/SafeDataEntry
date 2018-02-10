#
# Be sure to run `pod lib lint SafeDataEntry.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SafeDataEntry'
  s.version          = '0.1.0'
  s.summary          = 'An iOS library for validating user input.'

  s.description      = <<-DESC
An iOS library for validating user input
                       DESC

  s.homepage         = 'https://github.com/charles-oder/SafeDataEntry'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'charles-oder' => 'charles@oder.us' }
  s.source           = { :git => 'https://github.com/charles-oder/SafeDataEntry.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SafeDataEntry/Classes/**/*'
  
end
