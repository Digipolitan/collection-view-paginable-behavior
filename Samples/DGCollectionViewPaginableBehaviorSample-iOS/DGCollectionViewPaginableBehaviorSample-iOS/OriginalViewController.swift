//
//  ViewController.swift
//  DGCollectionViewPaginableBehaviorSample-iOS
//
//  Created by Benoit BRIATTE on 23/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import DGCollectionViewPaginableBehavior
import DGCollectionViewGridLayout

class OriginalViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.collectionView.register(UINib(nibName:String(describing:LoadingItemCell.self), bundle: Bundle.main),
		                             forCellWithReuseIdentifier: LoadingItemCell.Identifier)

		self.collectionView.register(UINib(nibName:String(describing:UserItemCell.self), bundle: Bundle.main),
		                             forCellWithReuseIdentifier: UserItemCell.Identifier)

		self.collectionView.register(UINib(nibName:String(describing: ReusableView.self), bundle:Bundle.main),
		                             forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
		                             withReuseIdentifier: ReusableView.Identifier)

		self.collectionView.register(UINib(nibName:String(describing: LoadingFooterView.self), bundle:Bundle.main),
		                             forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
		                             withReuseIdentifier: LoadingFooterView.Identifier)
	}
}
