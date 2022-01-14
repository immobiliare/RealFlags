Pod::Spec.new do |s|
  s.name         = "RealFlagsFirebase"
  s.version      = "1.1.3"
  s.summary      = "Feature flagging framework for Swift: FirebaseRemoteConfig Data Provider"
  s.homepage     = "https://github.com/immobiliare/RealFlags.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Immobiliarelabs" => "mobile@immobiliare.it" }
  s.social_media_url   = "https://twitter.com/immobiliarelabs"
  s.ios.deployment_target = '13.0'
  s.source           = {
    :git => 'https://github.com/immobiliare/RealFlags.git',
    :tag => s.version.to_s
  }
  s.swift_versions = ['5.0', '5.1', '5.3', '5.4', '5.5']
  s.framework = 'UIKit'

  s.source_files = 'RealFlagsFirebase/Sources/**/*.{h,m,swift}'
  s.dependency 'RealFlags', s.version.to_s
  s.dependency 'FirebaseCore', '~> 7.0'
  s.dependency 'FirebaseRemoteConfig', '~> 7.0'

end
