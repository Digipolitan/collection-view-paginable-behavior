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

	func set(statuses: (fetching:Bool, done: Bool, error: Error?)) {
		self.btnLoadMore.isHidden = true
		let title = statuses.error == nil ? "Load more" : "retry"
		self.btnLoadMore.setTitle(title, for: .normal)
		self.lblLoadedCount.isHidden = true


		if statuses.fetching {
			self.loaderActivity.startAnimating()
			return;
		}
		else {
			self.loaderActivity.stopAnimating()
		}

		if statuses.error != nil {
			self.btnLoadMore.isHidden = false
			return
		}

		if statuses.done {
			self.loaderActivity.stopAnimating()
			self.lblLoadedCount.isHidden = false
			return;
		}

		if !statuses.fetching {
			self.btnLoadMore.isHidden = false
		}
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
