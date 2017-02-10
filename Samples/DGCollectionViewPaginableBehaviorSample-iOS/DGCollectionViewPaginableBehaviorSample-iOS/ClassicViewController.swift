//
//  ClassicViewController.swift
//  DGCollectionViewPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGCollectionViewPaginableBehavior

class ClassicViewController: OriginalViewController {
	var users: [User] = [User]()
	let behavior: DGCollectionViewPaginableBehavior = DGCollectionViewPaginableBehavior()
	let control = UIRefreshControl()
	var refreshing: Bool = false
	override func viewDidLoad() {
		super.viewDidLoad()

		// initializing the model with some pre-installed elements
		self.users.append(User(firstName: "foor", lastName: "bar", company: "baz (1)"))

		self.collectionView.delegate	= self.behavior
		self.collectionView.dataSource	= self
		self.behavior.delegate = self
		
		self.control.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
		if #available(iOS 10.0, *) {
			self.collectionView.refreshControl = self.control
		} else {
			// Fallback on earlier versions
		}
	}

	func refresh() {
		self.refreshing = true
		self.users.removeAll()
		self.behavior.reloadData()
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.control.endRefreshing()
			self.refreshing = false
			self.behavior.fetchNextData(forSection: 0) {
				self.collectionView.reloadData()
			}
		}
	}
}

extension ClassicViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.users.count + (self.behavior.sectionStatus(forSection: section).done ? 0 : 1)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard indexPath.row < self.users.count else {
			let cell: LoadingItemCell = (collectionView.dequeueReusableCell(withReuseIdentifier: LoadingItemCell.Identifier, for: indexPath) as? LoadingItemCell)!
			if !self.refreshing {
				cell.set(moreToLoad: !self.behavior.sectionStatus(forSection: indexPath.section).done)
			}
			return cell
		}

		let cell: UserItemCell = (collectionView.dequeueReusableCell(withReuseIdentifier: UserItemCell.Identifier, for: indexPath) as? UserItemCell)!
		cell.set(user: self.users[indexPath.row])
		return cell
	}
}

extension ClassicViewController: DGCollectionViewPaginableBehaviorDelegate {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.collectionView.bounds.width / 3.5,
		              height: 200)
	}

	func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, countPerPageInSection section: Int) -> Int {
		return 3
	}

	func paginableBehavior(_ paginableBehavior: DGCollectionViewPaginableBehavior, fetchDataFrom indexPath: IndexPath, count: Int, completion: @escaping (Error?, Int) -> Void) {
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let results = User.stub(from: indexPath.row, with: count)
			self.users.append(contentsOf: results)

			print("fetching \(count) items from (\(indexPath.row))")
			completion(nil, results.count)
		}
	}
}
