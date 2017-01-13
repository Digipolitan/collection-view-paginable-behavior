//
//  User.swift
//  PaginableTableView
//
//  Created by Julien Sarazin on 19/12/2016.
//  Copyright © 2016 Julien Sarazin. All rights reserved.
//

import UIKit

class User: NSObject {
	var firstName: String = "unknown"
	var lastName: String = "unknown"
	var company: String = "unkown"

	static let list: [User] = [
		User(firstName: "foo", lastName: "bar", company: "baz (1)"),
		User(firstName: "foo", lastName: "bar", company: "bax (2)"),
		User(firstName: "foo", lastName: "bar", company: "baw (3)"),
		User(firstName: "foo", lastName: "bar", company: "bal (4)"),
		User(firstName: "foo", lastName: "bar", company: "baj (5)"),
		User(firstName: "foo", lastName: "bar", company: "bah (6)"),
		User(firstName: "foo", lastName: "bar", company: "bag (7)"),
		User(firstName: "foo", lastName: "bar", company: "baf (8)"),
		User(firstName: "foo", lastName: "bar", company: "bad (9)"),
		User(firstName: "foo", lastName: "bar", company: "bas (10)"),
		User(firstName: "foo", lastName: "bar", company: "baq (11)"),
		User(firstName: "foo", lastName: "bar", company: "bap (12)"),
		User(firstName: "foo", lastName: "bar", company: "bao (13)"),
		User(firstName: "foo", lastName: "bar", company: "bai (14)"),
		User(firstName: "foo", lastName: "bar", company: "bau (15)"),
		User(firstName: "foo", lastName: "bar", company: "bat (16)"),
		User(firstName: "foo", lastName: "bar", company: "bae (17)"),
		User(firstName: "foo", lastName: "bar", company: "baa (18)"),
		User(firstName: "foo", lastName: "bar", company: "bad (19)")
	]

	convenience init(firstName: String, lastName: String, company: String) {
		self.init()

		self.firstName = firstName
		self.lastName = lastName
		self.company = company
	}
}

extension User {
	static func from(_ dict: [String: Any]) -> User {
		let user = User()
		user.firstName	= dict["name.first"] as? String ?? "unkown"
		user.lastName	= dict["name.last"] as? String ?? "unkown"
		user.company	= dict["company"] as? String ?? "unkown"

		return user
	}
}

extension User {
	static func stub(from: Int, with count: Int) -> [User] {
		if from >= self.list.count - 1 {
			return []
		}

		let start = min(from, self.list.count - 2)
		let end = min(from+count-1, self.list.count - 1)

		return Array(self.list[start...end])
	}
}
