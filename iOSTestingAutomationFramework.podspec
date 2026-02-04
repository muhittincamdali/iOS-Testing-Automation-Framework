Pod::Spec.new do |s|
  s.name             = 'iOSTestingAutomationFramework'
  s.version          = '1.0.0'
  s.summary          = 'Comprehensive testing automation for iOS with XCTest integration.'
  s.description      = <<-DESC
    iOSTestingAutomationFramework provides comprehensive testing automation for iOS.
    Features include XCTest integration, UI testing utilities, accessibility testing,
    performance benchmarks, and continuous integration helpers.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/iOS-Testing-Automation-Framework'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'

  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'XCTest'
end
