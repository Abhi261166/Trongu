# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'
use_frameworks!

target 'Trongu' do
  # Comment the next line if you don't want to use dynamic frameworks
  

  # Pods for Trongu
pod 'YPImagePicker'
pod 'Socket.IO-Client-Swift', '~> 15.1.0'
pod 'IQKeyboardManager'
pod 'MultiSlider'
pod 'GrowingTextView', '0.7.2'
pod 'MultiSlider'
pod 'GoogleSignIn'
pod 'Firebase/Core'
pod 'FirebaseAuth'
pod 'FirebaseCrashlytics'
#pod 'FBSDKCoreKit'
#pod 'FBSDKLoginKit'
pod 'SDWebImage'
pod 'Kingfisher'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'
pod 'GoogleMaps'
pod 'Swifter', :git => "https://github.com/mattdonnelly/Swifter.git"

 post_install do |installer|
     installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
       end
     end
   end

end
