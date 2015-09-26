Pod::Spec.new do |s|
  s.name             = "KCKeyboardImagePicker"
  s.version          = "0.3.0"
  s.summary          = "A keyboard-sized scrolling image picker for IM apps."

  s.description      = <<-DESC
                       This scrolling image picker is inspired by the Facebook Messenger app.
                       Developer can attach up to four buttons on the top of a blureed effect for a selected image.
                       Check out the demo for more details.
                       DESC

  s.homepage         = "https://github.com/Kev1nChen/KCKeyboardImagePicker"
  s.license          = 'MIT'
  s.author           = 'Kevin Yufei Chen'
  s.source           = { :git => "https://github.com/Kev1nChen/KCKeyboardImagePicker.git", :tag => "#{s.version}" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'KCKeyboardImagePicker' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/*.h'
end
