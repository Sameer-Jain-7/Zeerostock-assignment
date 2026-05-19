//
//  UserCellViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation

struct UserCellViewModel {

    private let user: UserDataModel

    init(user: UserDataModel) {
        self.user = user
    }

    var nameText: String {
        "Full Name: \(user.name)"
    }

    var detailText: String {
        """
        Email: \(user.email)
        Role: \(user.role.capitalized)
        """
    }
}
