Pod::Spec.new do |s|

  s.name         = "PandaKit"
  s.version      = "0.0.1"
  s.summary      = "PandaKit is a quick develop collection base on open source projects."
  s.homepage     = "https://github.com/ForkPanda/PandaKit"
  s.license      = "MIT"
  s.author             = {
                          "ForkPanda" => "ForkPanda@gmail.com",
 }
  s.source        = { :git => "https://github.com/ForkPanda/PandaKit.git", :tag => s.version.to_s }
  s.source_files  = "PandaKit/**/*.{h,m}"
  s.platform      = :ios, '7.0'
  s.requires_arc  = true
  s.dependency "JDFPeekaboo"

end