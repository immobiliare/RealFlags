Pod::Spec.new do |s|
  s.name         = "IndomioFlags"
  s.version      = "1.0.0"
  s.summary      = "Feature flagging framework for Swift"
  s.homepage     = "https://github.com/immobiliare/IndomioFlags.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Immobiliarelabs" => "mobile@immobiliare.it" }
  s.social_media_url   = "https://twitter.com/immobiliarelabs"
  s.ios.deployment_target = '13.0'
  s.source           = {
    :git => 'https://github.com/immobiliare/IndomioFlags.git',
    :tag => s.version.to_s
  }
  s.swift_versions = ['5.0', '5.1', '5.3', '5.4', '5.5']
  s.framework = 'UIKit'

  s.source_files = 'IndomioFlags/Sources/**/*.{h,m,swift}'
  s.resource_bundles = {
    'IndomioFlags' => ['IndomioFlags/**/*.{png,storyboard,lproj,xcassets,xib}']
  }

end
