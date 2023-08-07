# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'
use_frameworks!

target 'Trongu' do
  # Comment the next line if you don't want to use dynamic frameworks
  

  # Pods for Trongu
pod 'YPImagePicker'
#pod 'SteviaLayout', '= 5.1.2'
#pod 'PryntTrimmerView', '= 4.0.2'
pod 'IQKeyboardManager'
pod 'MultiSlider'
pod 'GrowingTextView', '0.7.2'
pod 'MultiSlider'
pod 'GoogleSignIn'
pod 'Firebase/Core'
pod 'FirebaseAuth'
#pod 'FBSDKCoreKit'
#pod 'FBSDKLoginKit'
pod 'SDWebImage'
pod 'Kingfisher'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'


 post_install do |installer|
     installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
       end
     end
   end

end
