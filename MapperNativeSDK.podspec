Pod::Spec.new do |s|
  s.name             = 'MapperNativeSDK'
  s.version          = '0.1.0'
  s.summary          = 'MapperNativeSDK is for integration to Banks apps.'
  s.description      = 'This is SDK should be used by financial institutes'
  s.homepage         = 'https://github.com/btsdigital/MapperNativeSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Askar Syzdykov' => 'askar.syzdykov@aitupay.kz' }
  s.source           = { :git => 'https://github.com/btsdigital/MapperNativeSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version = '5'
  s.source_files = 'MapperNativeSDK/Classes/**/*.swift'
  s.frameworks = 'UIKit'
  s.dependency 'CryptoSwift', '= 1.3.1'
  s.dependency 'KeychainAccess', '= 4.2.0'
end
