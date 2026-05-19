//
//  UserService.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import FirebaseFirestore

final class UserService {

    static let shared = UserService()

    private init() {}

    func fetchUsers(
        completion: @escaping(Result<[UserDataModel], Error>) -> Void
    ) {

        Firestore.firestore()
            .collection("users")
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let users = documents.map {
                    UserDataModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }

                completion(.success(users))
            }
    }
}
