//
//  AuthService.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func login(
        email: String,
        password: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {
        
        auth.signIn(withEmail: email, password: password) { _, error in
            
            if let error = error {
                completion(.failure(error))
                print("Error in final class AuthService", error)
                return
            }
            
            completion(.success(()))
        }
    }
    
    func signup(
        name: String,
        email: String,
        password: String,
        role: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        auth.createUser(
            withEmail: email,
            password: password
        ) { result, error in

            if let error = error {

                completion(.failure(error))

                return
            }

            guard let user = result?.user else {
                return
            }

            let userId = user.uid

            // MARK: - Save name in FirebaseAuth profile

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { profileError in

                if let profileError = profileError {
                    completion(.failure(profileError))
                    return
                }

                // MARK: - Save user in Firestore

                let userData: [String: Any] = [
                    "name": name,
                    "email": email,
                    "role": role,
                    "createdAt": Timestamp()
                ]

                self.db.collection("users")
                    .document(userId)
                    .setData(userData) { firestoreError in
                        if let firestoreError = firestoreError {
                            completion(.failure(firestoreError))
                            return
                        }
                        completion(.success(()))
                    }
            }
        }
    }
}
