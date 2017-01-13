//
//  ViewController.swift
//  DGPaginableBehaviorSample-iOS
//
//  Created by Benoit BRIATTE on 23/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import DGPaginableBehavior

class ViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!

	var behavior: DGPaginableBehavior = DGPaginableBehavior()
	var users: [User] = [User(firstName: "foo", lastName: "bar", company: "baz (1)")]

	override func viewDidLoad() {
		super.viewDidLoad()
		behavior.delegate = self

		self.collectionView.delegate = behavior
		self.collectionView.dataSource = self

		self.collectionView.register(UINib(nibName:String(describing:LoadingItemCell.self), bundle: Bundle.main),
		                             forCellWithReuseIdentifier: LoadingItemCell.Identifier)

		self.collectionView.register(UINib(nibName:String(describing:UserItemCell.self), bundle: Bundle.main),
		                             forCellWithReuseIdentifier: UserItemCell.Identifier)

		self.collectionView.register(UINib(nibName:String(describing: ReusableView.self), bundle:Bundle.main),
		                             forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
		                             withReuseIdentifier: ReusableView.Identifier)

		self.collectionView.register(UINib(nibName:String(describing: ReusableView.self), bundle:Bundle.main),
		                             forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
		                             withReuseIdentifier: ReusableView.Identifier)

		self.collectionView.register(UINib(nibName:String(describing: FooterCollectionReusableView.self), bundle:Bundle.main),
		                             forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
		                             withReuseIdentifier: FooterCollectionReusableView.Identifier)

	}
}

extension ViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.users.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: UserItemCell = (collectionView.dequeueReusableCell(withReuseIdentifier: UserItemCell.Identifier, for: indexPath) as? UserItemCell)!
		cell.indexPath = indexPath
		cell.set(user: self.users[indexPath.row])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let loading = !self.behavior.isDoneLoading(section: indexPath.section)

		if loading {
			let footer: FooterCollectionReusableView? = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionReusableView.Identifier, for: indexPath) as? FooterCollectionReusableView
			return footer!
		}

		let view: ReusableView? = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableView.Identifier, for: indexPath) as? ReusableView
		return view!
	}

}

extension ViewController: DGPaginableBehaviorDelegate {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 100)
	}


	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, countPerPageInSection section: Int) -> Int {
		return 5
	}

	func paginableBehavior(_ paginableBehavior: DGPaginableBehavior, fetchDataFrom indexPath: IndexPath, with count: Int, completion: @escaping (Int) -> Void) {
		// Simulating 3 seconds delay
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let results = User.stub(from: indexPath.row, with: count)
			self.users.append(contentsOf: results)

			print("fetching \(count) items from (\(indexPath.section)), (\(indexPath.row)) ")
			completion(results.count)
		}
	}
}
