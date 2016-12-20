source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

# flag makes all dependencies build as frameworks
use_frameworks!

abstract_target 'GorgonBase' do

   # framework dependencies
   pod 'Swinject', '~> 2.0.0-beta.2'
   pod 'SwinjectPropertyLoader', '1.0.0-beta.2'

   target 'Gorgon' do
   end

   # test specific dependencies
   target 'GorgonTests' do
      pod 'Quick', '1.0.0'
      pod 'Nimble', '5.1.1'
   end
end

