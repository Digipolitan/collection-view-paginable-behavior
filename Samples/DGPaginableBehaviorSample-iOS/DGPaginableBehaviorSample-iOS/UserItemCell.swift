//
//  UserItemCell.swift
//  PaginableTableView
//
//  Created by Julien Sarazin on 19/12/2016.
//  Copyright © 2016 Julien Sarazin. All rights reserved.
//

import UIKit

class UserItemCell: UICollectionViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var companyLabel: UILabel!

	var indexPath: IndexPath?
	static let Identifier = "UserItemCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func set(user: User) {
		self.nameLabel.text = "\(user.firstName) \(user.lastName)"
		self.companyLabel.text = user.company
		if (self.indexPath?.section)! % 2 == 0 {
			self.contentView.backgroundColor = .red
		} else {
			self.contentView.backgroundColor = .blue
		}
	}
}
