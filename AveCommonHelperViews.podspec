Pod::Spec.new do |s|
    s.name             = 'AveCommonHelperViews'
    s.version          = '1.0.0'
    s.summary          = 'Commonly used helper views for UIKit (ShapeView, GradientView, RoundRectView, ContentTextView)'
    s.homepage         = 'https://github.com/AndreasVerhoeven/AveCommonHelperViews'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andreas Verhoeven' => 'cocoapods@aveapps.com' }
    s.source           = { :git => 'https://github.com/AndreasVerhoeven/AveCommonHelperViews.git', :tag => s.version.to_s }
    s.module_name      = 'AveCommonHelperViews'

    s.swift_versions = ['5.0']
    s.ios.deployment_target = '13.0'
    s.source_files = 'Sources/*.swift'
end
