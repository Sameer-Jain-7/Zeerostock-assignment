//
//  SupplierProductsViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation

final class SupplierProductsViewModel {

    private(set) var products: [ProductModel] = []
    private var lastProducts: [ProductModel] = []

    var onLoading: ((Bool) -> Void)?
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchProducts() {
        onLoading?(true)
        ProductService.shared.fetchSupplierProducts {
            [weak self] result in
            self?.onLoading?(false)
            switch result {
            case .success(let products):
                self?.products = products
                self?.lastProducts = products
                self?.onDataUpdated?()
            case .failure(let error):
                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }

    func refreshProductsIfNeeded() {

        ProductService.shared.fetchSupplierProducts {
            [weak self] result in

            switch result {

            case .success(let products):

                guard let self = self else {
                    return
                }

                let hasChanges =
                products.count != self.lastProducts.count ||

                zip(products, self.lastProducts).contains {

                    newProduct,
                    oldProduct in

                    newProduct.id != oldProduct.id ||
                    newProduct.approved != oldProduct.approved ||
                    newProduct.responded != oldProduct.responded
                }

                if hasChanges {

                    self.products = products
                    self.lastProducts = products

                    self.onDataUpdated?()
                }

            case .failure(let error):

                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
