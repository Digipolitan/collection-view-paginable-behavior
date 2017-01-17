//
//  MultipleSectionViewController.swift
//  DGCollectionViewPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGCollectionViewPaginableBehavior

class MultipleSectionsViewController: OriginalViewController {
	var users: [Int: [User]] = [Int: [User]]()

	let behavior: DGCollectionViewPaginableBehavior = DGCollectionViewPaginableBehavior()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureBehavior()

		// initializing the model with some pre-installed elements

		self.users = [
			0: [User(firstName: "foo", lastName: "bar", company: "baz(1)")],
			1: [User(firstName: "foo", lastName: "bar", company: "baz(1)")],
			2: [User(firstName: "foo", lastName: "bar", company: "baz(1)")]
		]

		self.collectionView.delegate	= self.behavior
		self.collectionView.dataSource	= self
		self.behavior.delegate = self
	}

	func configureBehavior() {
        self.behavior.options = DGCollectionViewPaginableBehavior.Options(automaticFetch: false)
	}
}


extension MultipleSectionsViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.users.keys.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.users[section]!.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: UserItemCell = (collectionView.dequeueReusableCell(withReuseIdentifier: UserItemCell.Identifier, for: indexPath) as? UserItemCell)!
		let data = self.users[indexPath.section]!
		cell.set(user: data[indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionElementKindSectionHeader {
            guard let header: ReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableView.Identifier, for: indexPath) as? ReusableView else {
                fatalError()
            }
			header.textLabel.text = "Header for section \(indexPath.section)"
			return header
		}

        guard let footer: LoadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.Identifier, for: indexPath) as? LoadingFooterView else {
            fatalError()
        }
		footer.set(sectionStatus: self.behavior.sectionStatus(forSection: indexPath.section))
		footer.set(indexPath: indexPath)
		footer.delegate = self
		return footer
	}
}

extension MultipleSectionsViewController: DGCollectionViewPaginableBehaviorDelegate {

	// MARK: UICollectionViewFlowDelegate
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width/4.4, height: 80)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 42)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 80)
	}

	// MARK: Paginable Behavior
	func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, countPerPageInSection section: Int) -> Int {
		return 3
	}

	func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, fetchDataFrom indexPath: IndexPath, count: Int, completion: @escaping (Error?, Int) -> Void) {
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let results = User.stub(from: indexPath.row, with: count)

			var data = self.users[indexPath.section]!
			data.append(contentsOf: results)
			self.users[indexPath.section] = data

			print("fetching \(count) items from (\(indexPath.section), (\(indexPath.row))")
			completion(nil, results.count)
		}
	}
}

extension MultipleSectionsViewController: LoadingFooterViewDelegate {
	func footer(_ footer: LoadingFooterView, loadMoreFromIndexPath indexPath: IndexPath) {
		self.behavior.fetchNextData(forSection: indexPath.section) {
			self.collectionView.reloadSections([indexPath.section])
		}
	}
}
