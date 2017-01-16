//
//  FooterCollectionReusableView.swift
//  DGPaginableBehaviorSample-iOS
//
//  Created by Julien Sarazin on 13/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import UIKit

protocol LoadingFooterViewDelegate: NSObjectProtocol {
	func footer(_ footer: LoadingFooterView, loadMoreFromIndexPath indexPath: IndexPath)
}

class LoadingFooterView: UICollectionReusableView {
	@IBOutlet weak var loaderActivity: UIActivityIndicatorView!
	@IBOutlet weak var lblLoadedCount: UILabel!
	@IBOutlet weak var btnLoadMore: UIButton!

	static let Identifier = "LoadingFooterViewReusableIdentifier"

	private var indexPath: IndexPath?
	weak var delegate: LoadingFooterViewDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	func set(moreToLoad: Bool) {
		self.loaderActivity.stopAnimating()
		self.loaderActivity.isHidden = true

		guard moreToLoad else {
			self.btnLoadMore.isHidden = true
			self.lblLoadedCount.isHidden = false
			return
		}

		self.btnLoadMore.isHidden = false
		self.lblLoadedCount.isHidden = true
	}

	func set(error: Error?) {
		let title = error == nil ? "Load more" : "retry"
		self.btnLoadMore.setTitle(title, for: .normal)
	}

	func set(indexPath: IndexPath) {
		self.indexPath = indexPath
		self.lblLoadedCount.text = "Loading done for section: \(indexPath.section)"
	}

	@IBAction func didTouchUpLoadMore(_ sender: Any) {
		self.btnLoadMore.isHidden = true
		self.loaderActivity.startAnimating()
		self.delegate?.footer(self, loadMoreFromIndexPath: self.indexPath!)
	}
}
