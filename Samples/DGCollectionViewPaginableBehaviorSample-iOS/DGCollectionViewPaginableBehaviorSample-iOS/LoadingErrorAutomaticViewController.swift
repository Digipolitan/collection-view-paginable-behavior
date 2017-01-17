//
//  LoadErrorManualViewController.swift
//  DGCollectionViewPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import UIKit
import DGCollectionViewPaginableBehavior

class LoadingErrorAutomaticViewController: OriginalViewController {
	var users: [User] = [User]()
	let behavior: DGCollectionViewPaginableBehavior = DGCollectionViewPaginableBehavior()
	var tries: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		self.collectionView.delegate	= self.behavior
		self.collectionView.dataSource	= self
		self.behavior.delegate = self
        self.behavior.fetchNextData(forSection: 0) {
			self.collectionView.reloadData()
		}
	}
}

extension LoadingErrorAutomaticViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.users.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: UserItemCell = (collectionView.dequeueReusableCell(withReuseIdentifier: UserItemCell.Identifier, for: indexPath) as? UserItemCell)!
		cell.set(user: self.users[indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer: LoadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.Identifier, for: indexPath) as! LoadingFooterView
		let sectionStatus = self.behavior.sectionStatus(forSection: indexPath.section)
		footer.set(sectionStatus: sectionStatus)
		footer.set(indexPath: indexPath)
		footer.delegate = self
		return footer
	}
}

extension LoadingErrorAutomaticViewController: DGCollectionViewPaginableBehaviorDelegate {

	// MARK: UICollectionViewFlowDelegate
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width/4.4, height: 80)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 80)
	}

	// MARK: Paginable Behavior
	func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, countPerPageInSection section: Int) -> Int {
		return 5
	}

	func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, fetchDataFrom indexPath: IndexPath, count: Int, completion: @escaping (Error?, Int) -> Void) {
		self.tries += 1
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			print("fetching \(count) items from (\(indexPath.section), (\(indexPath.row))")

			guard self.tries == 3 || self.tries % 2 == 0 else {
				let error = NSError(domain: "fake.error.domain", code: 0, userInfo: ["key": "some fake information"])
				completion(error, 0)
				return
			}

			let results = User.stub(from: indexPath.row, with: count)
			self.users.append(contentsOf: results)
			completion(nil, results.count)
		}
	}
}

extension LoadingErrorAutomaticViewController: LoadingFooterViewDelegate {
	func footer(_ footer: LoadingFooterView, loadMoreFromIndexPath indexPath: IndexPath) {
		self.behavior.fetchNextData(forSection: indexPath.section) {
			self.collectionView.reloadSections([indexPath.section])
		}
	}
}
