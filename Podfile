platform :ios, '7.0'

inhibit_all_warnings!

xcodeproj 'VLNRABLE/VLNRABLE.xcodeproj'

link_with 'VLNRABLE', 'VLNRABLETests'

pod 'AFNetworking', '~> 2.0.0'
pod 'CocoaLumberjack', '~> 1.8.1'
pod 'GoogleAnalytics-iOS-SDK', '~> 3.0.6'
pod 'GoogleTagManager', '~> 3.02'
pod 'M13Checkbox', '~> 1.0.0'
pod 'MZFormSheetController', '~> 2.3.3'
pod 'Nocilla', '~> 0.8.1'
pod 'NewRelicAgent', '~> 3.289'
pod 'Reachability', '~> 3.1.1'
pod 'SDWebImage', '~> 3.6'
pod 'SDWebImage-ProgressView', '~> 0.3.1'
pod 'SVProgressHUD', '~> 1.0'
pod 'TestFlightFeedback', '~> 2.1.0'
pod 'TestFlightLogger', '~> 0.0.3'
pod 'TestFlightSDK', '~> 3.0.0'
pod 'TTTAttributedLabel', '~> 1.9.4' 

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ARCHS'] = 'armv7 armv7s'
    end
  end
end
