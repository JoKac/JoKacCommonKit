Pod::Spec.new do |s|
  s.name          = "JoKacCommonKit"
  s.version       = "0.0.1"
  s.summary       = "常用的集合"
  s.description   = <<-DESC
                第一个版本
                   DESC
  s.homepage      = "https://github.com/JoKac/JoKacCommonKit.git"
  s.license       = {:type => "MIT", :file => "LICENSE" }
  s.author        = {"JoKac" => "wu7883235@qq.com"}
  s.platform      = :ios,"8.0"
  s.source        = {:git =>"https://github.com/JoKac/JoKacCommonKit.git", :tag => "v#{s.version}" }
  s.source_files = "JoKacBaseKit/*"
  s.requires_arc = true
end

