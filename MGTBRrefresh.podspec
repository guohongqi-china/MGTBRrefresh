#
#  Be sure to run `pod spec lint MGTBRrefresh.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MGTBRrefresh"
  s.version      = "0.0.1"
  s.summary      = "pull refresh"


  s.homepage     = "https://github.com/guohongqi-china/MGTBRrefresh"
  s.license      = "MIT"
  s.author             = { "guohongqi-china" => "820003039@qq.com" }


  s.platform     = :ios, "10.0"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/guohongqi-china/MGTBRrefresh.git", :tag => s.version.to_s }

  s.source_files  = "MGTBRrefresh/MGTBRrefresh.h"
  s.public_header_files = "MGTBRrefresh/MGTBRrefresh.h"

  s.requires_arc = true # 是否启用ARC
  s.frameworks = "UIKit", "Foundation" # 支持的框架
  pch_AF = <<-EOS
#ifndef TARGET_OS_IOS
  #define TARGET_OS_IOS TARGET_OS_IPHONE
#endif

EOS
  s.prefix_header_contents = pch_AF
  s.ios.deployment_target = '10.0'

  s.subspec 'FrameWork' do |ss|
    ss.source_files = 'MGTBRrefresh/Component/**/*.{h,m}'
    ss.public_header_files = 'MGTBRrefresh/Component/**/*.{h}'
    ss.ios.frameworks = 'MobileCoreServices', 'CoreGraphics'
  end

end
