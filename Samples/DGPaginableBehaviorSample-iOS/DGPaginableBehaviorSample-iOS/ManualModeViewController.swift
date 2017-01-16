//
//  ManualModeViewController.swift
//  DGPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGPaginableBehavior

class ManualModeViewController: OriginalViewController {
	var users: [User] = [User]()
	let behavior: DGPaginableBehavior = DGPaginableBehavior()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setManualMode()
		self.collectionView.delegate	= self.behavior
		self.collectionView.dataSource	= self
		self.behavior.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func setManualMode() {
		self.behavior.set(options: [
			.automaticFetch: false
			])
	}
}

extension ManualModeViewController: UICollectionViewDataSource {
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
		footer.set(statuses: self.behavior.statusesForSection(indexPath.section))
		footer.set(indexPath: indexPath)
		footer.delegate = self
		return footer
	}
}

extension ManualModeViewController: DGPaginableBehaviorDelegate {

	// MARK: UICollectionViewFlowDelegate
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width/4.4, height: 80)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 80)
	}

	// MARK: Paginable Behavior
	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, countPerPageInSection section: Int) -> Int {
		return 9
	}

	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, fetchDataFrom indexPath: IndexPath, with count: Int, completion: @escaping (Error?, Int) -> Void) {
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let results = User.stub(from: indexPath.row, with: count)
			self.users.append(contentsOf: results)

			print("fetching \(count) items from (\(indexPath.section), (\(indexPath.row))")
			completion(nil, results.count)
		}
	}
}

extension ManualModeViewController: LoadingFooterViewDelegate {
	func footer(_ footer: LoadingFooterView, loadMoreFromIndexPath indexPath: IndexPath) {
		self.behavior.fetchNext(indexPath.section) { (_) in
			self.collectionView.reloadSections([indexPath.section])
		}
	}
}
