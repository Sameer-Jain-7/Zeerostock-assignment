//
//  UserDataModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation
import FirebaseFirestore

struct UserDataModel {

    let id: String
    let name: String
    let email: String
    let role: String
    let createdAt: Timestamp?

    init(
        id: String,
        data: [String: Any]
    ) {
        self.id = id
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.role = data["role"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp
    }
}
