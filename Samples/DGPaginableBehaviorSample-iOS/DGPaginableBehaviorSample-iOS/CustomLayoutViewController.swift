//
//  CustomLayoutViewController.swift
//  DGPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGPaginableBehavior
import DGCollectionViewGridLayout

class CustomLayoutViewController: OriginalViewController {
	var users: [Int: [User]] = [Int: [User]]()

	let behavior: DGPaginableBehavior = DGPaginableBehavior()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureBehavior()
		self.configureCollectionViewLayout()

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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func configureBehavior() {
		self.behavior.set(options: [
			.automaticFetch: false
			])
	}

	func configureCollectionViewLayout() {
		let layout = DGCollectionViewGridLayout()
		layout.columnSpacing = 10
		layout.lineSpacing = 10
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

		self.collectionView.setCollectionViewLayout(layout, animated: true)
	}
}


extension CustomLayoutViewController: DGGridLayoutDataSource {
	// DGGridLayoutDataSource
	func numberOfColumnsIn(_ collectionView: UICollectionView) -> Int {
		return 2
	}

	// UICollectionView Datasource
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
			let header: ReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableView.Identifier, for: indexPath) as! ReusableView
			header.textLabel.text = "Header for section \(indexPath.section)"
			return header
		}

		let footer: LoadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.Identifier, for: indexPath) as! LoadingFooterView
		footer.set(moreToLoad: !self.behavior.statusesForSection(indexPath.section).done)
		footer.set(indexPath: indexPath)
		footer.delegate = self
		return footer
	}
}

extension CustomLayoutViewController: DGPaginableBehaviorDelegate {

	// MARK: Paginable Behavior
	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, countPerPageInSection section: Int) -> Int {
		return 3
	}

	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, fetchDataFrom indexPath: IndexPath, with count: Int, completion: @escaping (Error?, Int) -> Void) {
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

extension CustomLayoutViewController: LoadingFooterViewDelegate {
	func footer(_ footer: LoadingFooterView, loadMoreFromIndexPath indexPath: IndexPath) {
		self.behavior.fetchNext(indexPath.section) { (_) in
			self.collectionView.reloadSections([indexPath.section])
		}
	}
}

/**
Since the PAginable behavior is a partial implementation of UICollecitonViewDelegate,
It's the direct instance interavting with the collection View.
If your custom layout needs a delegate with specific methods, just extend the behavior of the Paginable component.
**/
extension DGPaginableBehavior: DGGridLayoutDelegate {
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: DGCollectionViewGridLayout, heightForItemAtIndexPath indexPath: IndexPath, columnWidth: CGFloat) -> CGFloat {
		return 90
	}

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: DGCollectionViewGridLayout, heightForHeaderInSection section: Int) -> CGFloat {
		return 42
	}

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: DGCollectionViewGridLayout, heightForFooterInSection section: Int) -> CGFloat {
		return 90
	}
}
