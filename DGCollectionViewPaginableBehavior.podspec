Pod::Spec.new do |s|
s.name = "DGCollectionViewPaginableBehavior"
s.version = "1.0.0"
s.summary = "This is a summary."
s.homepage = "https://github.com/Digipolitan/collection-view-paginable-behavior"
s.authors = "Digipolitan"
s.source = { :git => "https://github.com/Digipolitan/collection-view-paginable-behavior.git", :tag => "v#{s.version}" }
s.license = { :type => "BSD", :file => "LICENSE" }
s.source_files = 'Sources/**/*.{swift,h}'
s.ios.deployment_target = '8.0'
s.tvos.deployment_target = '9.0'
s.requires_arc = true
end