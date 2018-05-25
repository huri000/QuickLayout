#
# Be sure to run `pod lib lint QuickLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QuickLayout'
  s.version          = '2.0.2'
  s.summary          = 'Written in pure Swift, QuickLayout offers a neat way to manage Auto Layout in code.'
  s.platforms = { :ios => '9.0', :tvos => '9.0', :osx => '10.10' }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

s.description      = <<-DESC
QuickLayout offers an additional way to easily the layout constraints using only code. You can harness the power of QuickLayout to align your interface programmatically without even creating any constraints explicitly.
DESC

  s.homepage         = 'https://github.com/huri000/QuickLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Huri' => 'huri000@gmail.com' }
  s.source           = { :git => 'https://github.com/huri000/QuickLayout.git', :tag => s.version.to_s }
  s.source_files = 'QuickLayout/**/*.{swift,h}'  
end
