//
//  AdminApprovalViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation

final class AdminApprovalViewModel {

    private(set) var products: [ProductModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchProducts() {

        onLoading?(true)

        ProductService.shared.fetchAdminProducts {
            [weak self] result in

            self?.onLoading?(false)

            switch result {

            case .success(let products):

                self?.products = products
                self?.onDataUpdated?()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func approveProduct(
        productId: String
    ) {

        guard RoleManager.shared
            .canManageProducts else {
            return
        }

        ProductService.shared.approveProduct(
            productId: productId
        ) { [weak self] result in

            switch result {

            case .success:

                self?.fetchProducts()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func rejectProduct(
        productId: String
    ) {

        guard RoleManager.shared
            .canManageProducts else {
            return
        }

        ProductService.shared.rejectProduct(
            productId: productId
        ) { [weak self] result in

            switch result {

            case .success:

                self?.fetchProducts()

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
// super_admin email - Zeero.admin@gmail.com
// super_admin password - qwe123
