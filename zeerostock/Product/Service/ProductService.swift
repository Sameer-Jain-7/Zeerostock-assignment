//
//  ProductService.swift
//  zeerostock
//
//  Created by Sameer Jain on 19/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class ProductService {
    
    static let shared = ProductService()
    
    private init() {}
    
    func fetchProducts(completion: @escaping(Result<[ProductModel], Error>) -> Void) {
        
        Firestore.firestore()
            .collection("products")
            .whereField("approved", isEqualTo: true)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let products = documents.map {
                    ProductModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }
                
                completion(.success(products))
            }
    }
    
    func approveProduct(
        productId: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {
        
        Firestore.firestore()
            .collection("products")
            .document(productId)
            .updateData([
                "approved": true,
                "responded": true
            ]) { error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(()))
            }
    }
    
    func rejectProduct(
        productId: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {
        
        Firestore.firestore()
            .collection("products")
            .document(productId)
            .updateData([
                "approved": false,
                "responded": true
            ]) { error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(()))
            }
    }
    

    func fetchSupplierProducts(
        completion: @escaping(Result<[ProductModel], Error>) -> Void
    ) {

        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.success([]))
            return
        }

        Firestore.firestore()
            .collection("products")
            .whereField("createdBy", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let products = documents.map {
                    ProductModel(id: $0.documentID, data: $0.data())
                }

                completion(.success(products))
            }
    }

    func createProduct(
        title: String,
        description: String,
        price: Double,
        imageUrl: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {

        guard let userId = Auth.auth().currentUser?.uid else {

            completion(
                .failure(
                    NSError(
                        domain: "",
                        code: 401,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                            "User not logged in"
                        ]
                    )
                )
            )

            return
        }

        let productData: [String: Any] = [
            "title": title,
            "description": description,
            "price": price,
            "imageUrl": imageUrl,
            "createdBy": userId,
            "approved": false,
            "responded": false,
            "currency": "INR",
            "createdAt": Timestamp()
        ]

        Firestore.firestore()
            .collection("products")
            .addDocument(data: productData) { error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }
    }
    
    func fetchApprovedProducts(
        completion: @escaping(Result<[ProductModel], Error>) -> Void
    ) {

        Firestore.firestore()
            .collection("products")
            .whereField("approved", isEqualTo: true)
            .getDocuments { snapshot, error in

                if let error = error {

                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {

                    completion(.success([]))
                    return
                }

                let products = documents.map {

                    ProductModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }

                completion(.success(products))
            }
    }
    
    func fetchAdminProducts(
        completion: @escaping(Result<[ProductModel], Error>) -> Void
    ) {

        Firestore.firestore()
            .collection("products")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in

                if let error = error {

                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {

                    completion(.success([]))
                    return
                }

                let products = documents.map {

                    ProductModel(
                        id: $0.documentID,
                        data: $0.data()
                    )
                }

                completion(.success(products))
            }
    }
}
