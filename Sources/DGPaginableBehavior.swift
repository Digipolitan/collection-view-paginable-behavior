//
//  DGPaginableBehavior.swift
//  DGPaginableBehavior
//
//  Created by Julien Sarazin on 13/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit

@objc
public protocol DGPaginableBehaviorDelegate: UICollectionViewDelegateFlowLayout {
	@objc optional func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, countPerPageInSection section: Int) -> Int
	@objc optional func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, fetchDataFrom indexPath: IndexPath, with count: Int, completion: @escaping (Int) -> Void)
}


public enum DGPaginableBehaviorOptions: String {
	case automaticFetch = "DGPaginableBehaviorOptions.AutomaticFetch"
	case countPerPage = "DGPaginableBehaviorOptions.CountPerPage"
}

open class DGPaginableBehavior: NSObject {
	fileprivate(set) public var sectionInfo: [Int: (fetching: Bool, done: Bool)]
	fileprivate(set) var options: [DGPaginableBehaviorOptions: Any]
	fileprivate var lastIndexes: [Int: Int]

	public weak var delegate: DGPaginableBehaviorDelegate?

	public override init() {
		self.lastIndexes = [Int: Int]()
		self.sectionInfo = [Int: (fetching: Bool, done: Bool)]()
		self.options = [
			.automaticFetch: true,
			.countPerPage: 10
		]
	}

	open override func responds(to aSelector: Selector!) -> Bool {
		if let delegate = self.delegate,
			delegate.responds(to: aSelector) {
			return true
		}

		return super.responds(to: aSelector)
	}

	open override func forwardingTarget(for aSelector: Selector!) -> Any? {
		if let delegate = self.delegate,
			delegate.responds(to: aSelector) {
			return delegate
		}

		return nil
	}

	public func isDoneLoading(section: Int) -> Bool {
		return self.sectionInfo[section]?.done ?? false
	}

	public func set(options: [DGPaginableBehaviorOptions: Any]) {
		self.options = options
	}

	public func fetchNext(_ section: Int, done: @escaping (Void) -> Void) {
		var index = self.lastIndexes[section]
		if index == nil {
			index = 0
			self.lastIndexes[section] = index
		}

		let count = self.delegate?.paginableBehavior?(self, countPerPageInSection: section) ?? self.options[.countPerPage] as! Int
		var loadingInfo = self.sectionInfo[section]

		if loadingInfo == nil {
			loadingInfo = (fetching: false, done: false)
			self.sectionInfo[section] = loadingInfo
		}

		guard !loadingInfo!.fetching && !loadingInfo!.done else {
			return
		}

		loadingInfo!.fetching = true
		self.sectionInfo[section] = loadingInfo
		self.lastIndexes[section] = index! + count


		self.delegate?.paginableBehavior?(self,
		                                  fetchDataFrom: IndexPath(item:index!, section: section),
		                                  with: count,
		                                  completion: { (elementsCount) in
											loadingInfo!.fetching = false
											loadingInfo!.done = (elementsCount == 0 || elementsCount < count)
											self.sectionInfo[section] = loadingInfo
											if (done != nil) {
												done();
											}
		})
	}
}

extension DGPaginableBehavior: UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		self.delegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)

		// If the element that will be displayed is not the last,
		// means we did not reach the end of the collection.
		guard indexPath.row >= (collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - 1) else {
			return
		}

		var index = self.lastIndexes[indexPath.section] = indexPath.row + 1

		let automatic: Bool = self.options[.automaticFetch] as! Bool
		if (automatic) {
			self.fetchNext(indexPath.section) {
				collectionView.reloadSections([indexPath.section])
			}
		}
	}
}
