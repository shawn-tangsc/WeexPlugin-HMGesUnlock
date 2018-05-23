Pod::Spec.new do |s|
s.name         = "WeexHMGesUnlock"
s.version      = "1.0.0"
s.summary      = "WeexHMGesUnlock Source ."
s.homepage     = 'https://github.com/shawn-tangsc/weex-plugin-ios-gesture.git'
s.license      = "MIT"
s.authors      = { "tangsicheng" => "tangscsh@icloud.com" }
s.platform     = :ios
s.ios.deployment_target = "8.0"
s.source = { :git => 'https://github.com/shawn-tangsc/weex-plugin-ios-gesture.git', :tag => s.version.to_s }

s.source_files = "Source/*.{h,m,mm}","Source/Gesture Page/*.{h,m,mm}"

end
