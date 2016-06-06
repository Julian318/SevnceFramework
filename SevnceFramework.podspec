Pod::Spec.new do |s|
  s.name         = 'SevnceFramework'
  s.version      = '1.0.1'
  s.summary      = 'Enterprise Framework for iOS.'
  s.homepage     = 'https://github.com/Julian318/SevnceFramework'
  s.platform     = :ios, '9.0'  
  s.license      = 'MIT'
  s.author       = { 'Julian318' => '75820809@qq.com' }
  s.source       = { :git => "https://github.com/Julian318/SevnceFramework.git", :tag => s.version }
  s.source_files = "Sevnce/**/*.{h,m}"
  s.framework    = 'UIKit','Foundation'
  s.requires_arc = true
end

