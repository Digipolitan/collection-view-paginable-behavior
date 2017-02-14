Pod::Spec.new do |s|
s.name = "DGCollectionViewPaginableBehavior"
s.version = "1.0.4"
s.summary = "Allows you to paginate your collection of data with only few lines of code"
s.homepage = "https://github.com/Digipolitan/collection-view-paginable-behavior-swift"
s.authors = "Digipolitan"
s.source = { :git => "https://github.com/Digipolitan/collection-view-paginable-behavior-swift.git", :tag => "v#{s.version}" }
s.license = { :type => "BSD", :file => "LICENSE" }
s.source_files = 'Sources/**/*.{swift,h}'
s.ios.deployment_target = '8.0'
s.tvos.deployment_target = '9.0'
s.requires_arc = true
end
