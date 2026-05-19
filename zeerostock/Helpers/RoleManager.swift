//
//  RoleManager.swift
//  zeerostock
//
//  Created by Sameer Jain on 18/05/26.
//

import Foundation

final class RoleManager {

    static let shared = RoleManager()

    private init() {}

    var currentRole: String = ""

    // MARK: - Permissions

    var canManageProducts: Bool {

        currentRole == "super_admin" ||
        currentRole == "product_admin"
    }

    var canManageAuctions: Bool {

        currentRole == "super_admin" ||
        currentRole == "auction_admin"
    }

    var isSuperAdmin: Bool {

        currentRole == "super_admin"
    }
}
