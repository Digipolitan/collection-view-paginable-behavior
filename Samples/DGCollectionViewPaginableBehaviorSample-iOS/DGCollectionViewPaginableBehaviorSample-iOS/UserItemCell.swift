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

	static let Identifier = "UserItemCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func set(user: User) {
		self.nameLabel.text = "\(user.firstName) \(user.lastName)"
		self.companyLabel.text = user.company
		let htmlString = "<h1>Header</h1><h2>Subheader</h2><p>Some <em>text</em></p><img src='http://68.media.tumblr.com/c06b9a1fb051899055827ee8c7503cef/tumblr_ol2c7iyO261v1wvcuo1_1280.jpg' width=70 height=100 />"
		do {
			let attributedString = try NSAttributedString(data: htmlString.data(using: .unicode, allowLossyConversion: true)!,
			                                              options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
			self.nameLabel.attributedText = attributedString
		}
		catch {}

	}
}
