Pod::Spec.new do |s|
  s.name         = "VHUD"
  s.version      = "1.4.0"
  s.summary      = "Simple HUD."
  s.homepage     = "https://github.com/xxxAIRINxxx/VHUD"
  s.license      = 'MIT'
  s.author       = { "Airin" => "xl1138@gmail.com" }
  s.source       = { :git => "https://github.com/xxxAIRINxxx/VHUD.git", :tag => s.version.to_s }

  s.requires_arc = true
  s.platform     = :ios, '9.0'

  s.source_files = 'Sources/*.swift'
end
