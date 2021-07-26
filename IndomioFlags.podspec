Pod::Spec.new do |s|
  s.name         = "IndomioFlags"
  s.version      = "1.0.0"
  s.summary      = "Feature flagging framework for Swift"
  s.homepage     = "https://github.com/malcommac/IndomioFlags.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniele Margutti" => "mobile@immobiliare.it" }
  s.social_media_url   = "https://twitter.com/danielemargutti"
  s.ios.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  s.tvos.deployment_target = '6.0'
  s.source           = {
    :git => 'https://github.com/malcommac/IndomioFlags.git',
    :tag => s.version.to_s
  }
  s.swift_versions = ['5.0', '5.1', '5.3', '5.4', '5.5']
  s.framework = 'UIKit'

  s.default_subspec = 'IndomioFlags'

  s.subspec 'IndomioFlags' do |ss|
    ss.source_files = 'IndomioFlags/Sources/**/*.{h,m,swift}'
    ss.resource_bundles = {
      'IndomioFlags' => ['IndomioFlags/**/*.{png,storyboard,lproj,xcassets,xib}']
    }
  end

  s.subspec 'IndomioFlagsFirebase' do |ss|
    ss.source_files = 'IndomioFlagsFirebase/Sources/**/*.{h,m,swift}'
    ss.dependency 'FirebaseRemoteConfig'
  end

end
