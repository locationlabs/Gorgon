Pod::Spec.new do |s|
  s.name                      = 'Gorgon'
  s.module_name               = 'Gorgon'
  s.version                   = '1.1.0'
  s.summary                   = 'Application daemon framework for Single Responsibility Principle abstractions of the UIApplicationDelegate'
  s.homepage                  = 'http://www.locationlabs.com'
  s.license                   = 'APL2'
  s.author                    = { 'Location Labs' => 'iosswiftdevelop@locationlabs.com' }
  s.ios.deployment_target     = '8.0'
  s.requires_arc              = true
  s.source                    = { :git => 'https://github.com/locationlabs/Medusa.git', :tag => s.version }  
  s.source_files              = 'Sources/**/*.{h,swift}'

  s.dependency 'Swinject', '~> 2.0.0-beta.2'
  s.dependency 'SwinjectPropertyLoader', '1.0.0-beta.2'

end
