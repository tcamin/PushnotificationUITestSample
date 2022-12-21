# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

platform :ios, '12.0' 

target 'PushNotificationDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  target 'PushNotificationDemoUITests' do
    # Pods for testing
    pod 'SBTUITestTunnelHost'
  end
end

post_install do |installer|
  puts "Fetching SBTUITestTunnelHost Server"
  system("curl -s https://raw.githubusercontent.com/Subito-it/SBTUITestTunnelHost/master/SBTUITunnelHostServer/Binary/SBTUITestTunnelServer.zip > /tmp/SBTUITestTunnelServer.zip; unzip -qqo /tmp/SBTUITestTunnelServer.zip -d #{installer.pods_project.path.dirname}/SBTUITestTunnelHost && rm -rf /tmp/SBTUITestTunnelServer.zip")
end
