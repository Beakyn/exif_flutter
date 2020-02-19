Pod::Spec.new do |s|
  s.name             = 'libexif'
  s.version          = '0.6.21.1'
  s.summary          = 'exif tool for iOS'

  s.description      = <<-DESC
media exif tool for iOS
                       DESC

  s.homepage         = 'https://github.com/John1261/libexif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'John' => 'john' }
  s.source           = { :git => 'https://github.com/John1261/libexif.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'libexif/libexif/*.framework/Headers/*.h'
  s.ios.vendored_frameworks = 'libexif/libexif/*.framework'

end
