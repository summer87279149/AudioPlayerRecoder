Pod::Spec.new do |s|
  s.name         = "XTPlayerRecoder"
  s.version      = "0.0.2"
  s.summary      = "Player and recoder by AVFoundation"
  s.homepage     = "https://github.com/summer87279149/AudioPlayerRecoder"
  s.license      = "MIT"
  s.author             = { "Summer" => "1033948449@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/summer87279149/AudioPlayerRecoder.git", :tag => "0.0.2" }
  s.source_files  = "XTPlayerRecoder", "XTPlayerRecoder/*.{h,m}"
  s.framework = 'UIKit'
end
