platform :ios, '10.0'
use_frameworks!

target 'CardScanner' do
        pod 'SwiftyJSON'
        pod 'SQLite.swift', '0.12.2'
        #pod 'TaskQueue'
        pod 'ImagePicker'
        pod 'BarcodeScanner'
        pod 'Validator', '3.2.1'
        pod 'GoneVisible'
        pod 'AWSCore', '~> 2.6.13'
        pod 'AWSS3'
        pod 'FLAnimatedImage'
        pod 'EasyTipView', '~> 2.0.4'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
            config.build_settings['ENABLE_BITCODE'] = 'YES'  
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
            #config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"

        end
    end
end
