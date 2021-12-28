Pod::Spec.new do |spec|
  spec.name         = "MZDatePicker"
  spec.version      = "0.0.1"
  spec.summary      = "swift扁平化日期选择组件、包含View和Controller两种形式"
  spec.homepage     = "https://github.com/1691665955/MZDatePicker"
  spec.authors         = { 'MZ' => '1691665955@qq.com' }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.source = { :git => "https://github.com/1691665955/MZDatePicker.git", :tag => spec.version}
  spec.platform     = :ios, "9.0"
  spec.swift_version = '5.0'
  spec.source_files  = "MZDatePicker/MZDatePicker/*"
  spec.dependency = 'MZAlertController'
end
