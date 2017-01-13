//
//  LoadingCollectionViewCell.swift
//  PaginableTableView
//
//  Created by Julien Sarazin on 19/12/2016.
//  Copyright © 2016 Julien Sarazin. All rights reserved.
//

import UIKit

class LoadingItemCell: UICollectionViewCell {
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

	static let Identifier = "LoadingItemCell"

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func set(moreToLoad: Bool) {
		if moreToLoad {
			self.loadingIndicator.startAnimating()
			self.loadingIndicator.isHidden = false
		} else {
			self.loadingIndicator.stopAnimating()
		}
	}
}
