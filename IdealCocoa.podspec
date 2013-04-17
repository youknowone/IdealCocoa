Pod::Spec.new do |s|
  s.name         = "IdealCocoa"
  s.version      = "0.12.2.0"
  s.summary      = "Cocoa/UIKit utility collections."
  s.homepage     = "https://github.com/youknowone/IdealCocoa"
  s.license      = "2-clause BSD"
  s.author       = { "Jeong YunWon" => "jeong@youknowone.org" }
  s.source       = { :git => "https://github.com/youknowone/IdealCocoa.git", :tag => "pod-0.12.2.0" }

  s.subspec "IdealCocoa" do |ss|
    ss.source_files = "IdealCocoa"
    ss.header_dir = "IdealCocoa"
    ss.public_header_files = "IdealCocoa/*.h"
    ss.dependency "FoundationExtension"
  end

  s.subspec "IdealUIKit" do |ss|
    ss.platform     = :ios
    ss.source_files = "IdealUIKit"
    ss.header_dir = "IdealUIKit"
    ss.public_header_files = "IdealUIKit/*.h"
    ss.frameworks = 'CoreText', 'OpenGLES'
    ss.dependency "IdealCocoa/IdealCocoa"
    ss.dependency "FoundationExtension/UIKitExtension"
  end
end
