# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'TMobileTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftLint'
  
  target 'TMobileTestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TMobileTestUITests' do
    # Pods for testing
  end
  
  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
  end

end
