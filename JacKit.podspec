Pod::Spec.new do |s|
  s.name             = 'JacKit'
  s.version          = '1.0'
  s.summary          = 'JacKit, my iOS developing logging tool'
  s.description      = <<-DESC
  Wrap CocoaLumberjack to embrace Swift syntax.
  File based logging level control.
  A HTTP logger to send events to JacServer, so that I can view my logs in a
  Tmux window, cleaned up and prettified.
  DESC

  s.homepage         = 'https://github.com/mudox/jac-kit'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Mudox'

  s.source           = { :git => 'https://github.com/mudox/jac-kit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'JacKit/**/*'

  s.dependency 'CocoaLumberjack/Swift', '~> 3.3.0'
end
