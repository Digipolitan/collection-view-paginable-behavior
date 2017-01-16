workspace 'DGPaginableBehavior.xcworkspace'

## Frameworks targets
abstract_target 'Frameworks' do
	use_frameworks!
	target 'DGPaginableBehavior-iOS' do
		platform :ios, '8.0'
	end
end

## Tests targets
abstract_target 'Tests' do
	use_frameworks!
	target 'DGPaginableBehaviorTests-iOS' do
		platform :ios, '8.0'
	end
end

## Samples targets
abstract_target 'Samples' do
	use_frameworks!

	pod 'DGCollectionViewGridLayout'
	target 'DGPaginableBehaviorSample-iOS' do
		project 'Samples/DGPaginableBehaviorSample-iOS/DGPaginableBehaviorSample-iOS'
		platform :ios, '8.0'
	end
end
