Pod::Spec.new do |s|
  s.name         = "IdealCocoa"
  s.version      = "0.12.1.0"
  s.summary      = "Cocoa/UIKit utility collections."
  s.homepage     = "https://github.com/youknowone/IdealCocoa"
  s.license      = ""
  s.author       = { "Jeong YunWon" => "jeong@youknowone.org" }
  s.source       = { :git => "https://github.com/youknowone/IdealCocoa.git", :tag => "pod-0.12.1.0" }
  s.prefix_header_contents = '
    #import <cdebug/debug.h>
    #import <FoundationExtension/FoundationExtension.h>
    #if TARGET_OS_IPHONE
        #import <UIKitExtension/UIKitExtension.h>
    #endif
  '

  s.subspec "IdealCocoa" do |ss|
    ss.source_files = "IdealCocoa"
    ss.dependency "FoundationExtension"
  end

  s.subspec "IdealUIKit" do |ss|
    ss.platform     = :ios
    ss.source_files = "IdealUIKit"
    ss.header_dir = "IdealUIKit"
    ss.dependency "IdealCocoa/IdealCocoa"
    ss.dependency "FoundationExtension/UIKitExtension"
  end
end
