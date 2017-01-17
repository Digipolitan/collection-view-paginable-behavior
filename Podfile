workspace 'DGCollectionViewPaginableBehavior.xcworkspace'

## Frameworks targets
abstract_target 'Frameworks' do
	use_frameworks!
	target 'DGCollectionViewPaginableBehavior-iOS' do
		platform :ios, '8.0'
	end

	target 'DGCollectionViewPaginableBehavior-tvOS' do
		platform :tvos, '9.0'
	end
end

## Tests targets
abstract_target 'Tests' do
	use_frameworks!
	target 'DGCollectionViewPaginableBehaviorTests-iOS' do
		platform :ios, '8.0'
	end

	target 'DGCollectionViewPaginableBehaviorTests-tvOS' do
		platform :tvos, '9.0'
	end
end

## Samples targets
abstract_target 'Samples' do
	use_frameworks!

	target 'DGCollectionViewPaginableBehaviorSample-iOS' do
		project 'Samples/DGCollectionViewPaginableBehaviorSample-iOS/DGCollectionViewPaginableBehaviorSample-iOS'
        pod 'DGCollectionViewGridLayout'

		platform :ios, '8.0'
	end

	target 'DGCollectionViewPaginableBehaviorSample-tvOS' do
		project 'Samples/DGCollectionViewPaginableBehaviorSample-tvOS/DGCollectionViewPaginableBehaviorSample-tvOS'
		platform :tvos, '9.0'
	end
end
