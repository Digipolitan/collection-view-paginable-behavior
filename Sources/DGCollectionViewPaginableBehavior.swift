//
//  DGCollectionViewPaginableBehavior.swift
//  DGCollectionViewPaginableBehavior
//
//  Created by Julien Sarazin on 13/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit

@objc
public protocol DGCollectionViewPaginableBehaviorDelegate: UICollectionViewDelegateFlowLayout {
	/**
	* Gives the number of items to fetch for a given section.
	*/
	@objc optional func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, countPerPageInSection section: Int) -> Int
	/**
	* Core methods that will be called every time the user reach the end of the collection. Depending on the mode set for automatic fetch.
	*/
	@objc optional func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, fetchDataFrom indexPath: IndexPath, count: Int, completion: @escaping (Error?, Int) -> Void)
}

open class DGCollectionViewPaginableBehavior: NSObject {

    public struct Options: CustomStringConvertible {

        public var automaticFetch: Bool
        public var countPerPage: Int

        public init(automaticFetch: Bool = true, countPerPage: Int = 10) {
            self.automaticFetch = automaticFetch
            self.countPerPage = countPerPage
        }

        public var description: String {
            return "[DGCollectionViewPaginableBehavior.Options automaticFetch:\(self.automaticFetch), countPerPage:\(self.countPerPage)]"
        }
    }

    public struct SectionStatus: CustomStringConvertible {

        public var fetching: Bool
        public var done: Bool
        public var error: Error?

        public init(fetching: Bool = false, done: Bool = false, error: Error? = nil) {
            self.fetching = fetching
            self.done = done
            self.error = error
        }

        public var description: String {
            return "[DGCollectionViewPaginableBehavior.SectionStatus fetching:\(self.fetching), done:\(self.done), error:\(self.error)]"
        }
    }

	open var options: Options
	fileprivate var sectionInfo: [Int: SectionStatus]
    fileprivate var lastIndexes: [Int: Int]

	public weak var delegate: DGCollectionViewPaginableBehaviorDelegate?

	public override init() {
		self.lastIndexes = [Int: Int]()
		self.sectionInfo = [Int: SectionStatus]()
		self.options = Options()
        super.init()
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

	public func sectionStatus(forSection section: Int) -> SectionStatus {
		return self.sectionInfo[section] ?? SectionStatus()
	}

	public func fetchNextData(forSection section: Int, completionHandler: @escaping (Void) -> Void) {
		let index = self.lastIndexes[section] ?? 0
		self.lastIndexes[section] = index

		let count = self.delegate?.paginableBehavior?(self, countPerPageInSection: section) ?? self.options.countPerPage

        var sectionStatus = self.sectionInfo[section] ?? SectionStatus()
        guard !sectionStatus.fetching && !sectionStatus.done else {
            self.sectionInfo[section] = sectionStatus
            return
        }

        sectionStatus.fetching = true
        self.sectionInfo[section] = sectionStatus
        let fromIndexPath = IndexPath(item:index, section: section)
        self.delegate?.paginableBehavior?(self, fetchDataFrom: fromIndexPath, count: count, completion: { (error, dataCount) in
            if error == nil {
                sectionStatus.done = (dataCount == 0 || dataCount < count)
                self.lastIndexes[section] = index + count
            }
            sectionStatus.error = error
            sectionStatus.fetching = false
            self.sectionInfo[section] = sectionStatus
            completionHandler()
        })
	}
}

extension DGCollectionViewPaginableBehavior: UICollectionViewDelegateFlowLayout {
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		self.delegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
		// If the element that will be displayed is not the last,
		// means we did not reach the end of the collection.
		guard let dataSource = collectionView.dataSource,
            indexPath.row >= (dataSource.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - 1) else {
			return
		}

		self.lastIndexes[indexPath.section] = indexPath.row + 1

		let sectionStatus = self.sectionStatus(forSection: indexPath.section)
		if self.options.automaticFetch && sectionStatus.error == nil {
            self.fetchNextData(forSection: indexPath.section) {
                collectionView.reloadSections([indexPath.section])
            }
		}
	}
}
