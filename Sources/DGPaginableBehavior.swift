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
	@objc optional func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, fetchDataFrom indexPath: IndexPath, with count: Int, completion: @escaping (Error?, Int) -> Void)
}


public enum DGPaginableBehaviorOptions: String {
	case automaticFetch = "DGPaginableBehaviorOptions.AutomaticFetch"
	case countPerPage = "DGPaginableBehaviorOptions.CountPerPage"
}

open class DGPaginableBehavior: NSObject {
	fileprivate(set) public var sectionInfo: [Int: (fetching: Bool, done: Bool, error: Error?)]
	fileprivate(set) var options: [DGPaginableBehaviorOptions: Any]
	fileprivate var lastIndexes: [Int: Int]

	public weak var delegate: DGPaginableBehaviorDelegate?

	public override init() {
		self.lastIndexes = [Int: Int]()
		self.sectionInfo = [Int: (fetching: Bool, done: Bool, error: Error?)]()
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

	public func statusesForSection(_ section: Int) -> (fetching: Bool, done: Bool, error: Error?) {
		return self.sectionInfo[section] ?? (fetching: false, done: false, error: nil)
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
			loadingInfo = (fetching: false, done: false, error: nil)
			self.sectionInfo[section] = loadingInfo
		}

		guard !loadingInfo!.fetching && !loadingInfo!.done else {
			return
		}

		loadingInfo!.fetching = true
		self.sectionInfo[section] = loadingInfo

		self.delegate?.paginableBehavior?(self,
		                                  fetchDataFrom: IndexPath(item:index!, section: section),
		                                  with: count,
		                                  completion: { (error, elementsCount) in
											if error == nil {
												loadingInfo!.done = (elementsCount == 0 || elementsCount < count)
												self.lastIndexes[section] = index! + count
											}

											loadingInfo!.error = error
											loadingInfo!.fetching = false
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
		let statuses = self.statusesForSection(indexPath.section)

		if (automatic && statuses.error == nil) {
			self.fetchNext(indexPath.section) {
				collectionView.reloadSections([indexPath.section])
			}
		}
	}
}
