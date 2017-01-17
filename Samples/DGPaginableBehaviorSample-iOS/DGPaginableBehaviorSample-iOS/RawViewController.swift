//
//  RawViewController.swift
//  DGPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 16/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit
import DGPaginableBehavior

class RawViewController: OriginalViewController {
	var users: [User] = [User]()
	let behavior: DGPaginableBehavior = DGPaginableBehavior()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.collectionView.delegate	= self.behavior
		self.collectionView.dataSource	= self
		self.behavior.delegate = self

		// initial call to fetch the first chunk of data.
		self.behavior.fetchNextData(forSection: 0) {
			self.collectionView.reloadData()
		}
    }
}


extension RawViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.users.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: UserItemCell = (collectionView.dequeueReusableCell(withReuseIdentifier: UserItemCell.Identifier, for: indexPath) as? UserItemCell)!
		cell.set(user: self.users[indexPath.row])
		return cell
	}
}

extension RawViewController: DGPaginableBehaviorDelegate {
	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, fetchDataFrom indexPath: IndexPath, count: Int, completion: @escaping (Error?, Int) -> Void) {
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let results = User.stub(from: indexPath.row, with: count)
			self.users.append(contentsOf: results)

			print("fetching \(count) items from (\(indexPath.row))")
			completion(nil, results.count)
		}
	}
}
