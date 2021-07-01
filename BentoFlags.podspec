Pod::Spec.new do |s|
  s.name         = "BentoFlags"
  s.version      = "1.0.0"
  s.summary      = "Easily manage feature flags in Swift"
  s.homepage     = "https://github.com/malcommac/BentoFlags.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniele Margutti" => "hello@danielemargutti.com" }
  s.social_media_url   = "https://twitter.com/danielemargutti"
  s.ios.deployment_target = '12.0'
  s.source           = {
    :git => 'https://github.com/malcommac/BentoFlags.git',
    :tag => s.version.to_s
  }
  s.swift_versions = ['5.0', '5.1', '5.3', '5.4', '5.5']
  s.framework = 'UIKit'

  s.default_subspec = 'BentoFlags'

  s.subspec 'BentoFlags' do |ss|
    ss.source_files = 'BentoFlags/Sources/**/*'
  end

  s.subspec 'BentoFlagsFirebase' do |ss|
    ss.source_files = 'BentoFlagsFirebase/Sources/**/*'
    ss.dependency 'FirebaseRemoteConfig'
  end

end
