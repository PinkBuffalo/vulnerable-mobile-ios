platform :ios, '7.0'

inhibit_all_warnings!

xcodeproj 'VLNRABLE/VLNRABLE.xcodeproj'

link_with 'VLNRABLE', 'VLNRABLETests'

pod 'AFNetworking', '~> 2.0.0'
pod 'CocoaLumberjack', '~> 1.8.1'
pod 'DateTools', '~> 1.2.0'
pod 'Nocilla', '~> 0.8.1'
pod 'Parse', '~> 1.2.19'
pod 'SDWebImage', '~> 3.6'
pod 'SDWebImage-ProgressView', '~> 0.3.1'
pod 'SVProgressHUD', '~> 1.0'
pod 'TTTAttributedLabel', '~> 1.9.4'

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ARCHS'] = 'armv7 armv7s'
    end
  end
end
