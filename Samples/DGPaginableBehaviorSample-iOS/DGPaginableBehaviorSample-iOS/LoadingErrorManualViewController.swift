//
//  LoadingErrorViewController.swift
//  DGPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGPaginableBehavior

class LoadingErrorViewController: OriginalViewController {
	var users: [User] = [User]()
	let behavior: DGPaginableBehavior = DGPaginableBehavior()
	var tries: Int = 0

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

extension LoadingErrorViewController: UICollectionViewDataSource {
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

extension LoadingErrorViewController: DGPaginableBehaviorDelegate {

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
		self.tries += 1
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			print("fetching \(count) items from (\(indexPath.section), (\(indexPath.row))")

			// Simulating erros for the 1st and 2nd attempt
			guard self.tries > 2 else {
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

extension LoadingErrorViewController: LoadingFooterViewDelegate {
	func footer(_ footer: LoadingFooterView, loadMoreFromIndexPath indexPath: IndexPath) {
		self.behavior.fetchNext(indexPath.section) { (_) in
			self.collectionView.reloadSections([indexPath.section])
		}
	}
}
