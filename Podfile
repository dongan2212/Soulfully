# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

def utility
  pod 'SwiftLint'
end

def ui
  pod 'SkyFloatingLabelTextField'
  pod 'SkeletonView'
  pod 'DZNEmptyDataSet'
  pod 'SVProgressHUD'
  pod 'IQKeyboardManagerSwift'
end

def social
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
end

target 'Soulfully' do
  utility
  ui
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
end