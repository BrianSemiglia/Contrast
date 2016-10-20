#
# Be sure to run `pod lib lint Contrast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Contrast'
  s.version          = '0.1.0'
  s.summary          = 'A library for finding differences in 2-dimensional sets.'
  s.homepage         = 'https://github.com/briansemiglia/Contrast'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Brian Semiglia' => 'brian.semiglia@gmail.com' }
  s.source           = { :git => 'https://github.com/briansemiglia/Contrast.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Contrast/Classes/**/*'
end
