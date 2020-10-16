#
# Be sure to run `pod lib lint InputTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InputTextField'
  s.version          = '0.0.1'
  s.summary          = 'InputTextField is design library pod'
  s.description      = "InputTextField is a component, which was built base on UITextFiled. It will show animation when users typing"
  s.homepage         = 'https://github.com/nguyenhoangit57'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hoang Nguyen' => 'hoangnguyen4005@gmail.com' }
  s.source           = { :git => 'https://github.com/nguyenhoangit57/InputTextField', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'InputTextField/Classes/**/*'
end
