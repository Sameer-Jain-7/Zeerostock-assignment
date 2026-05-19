//
//  SupplierProductsViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation

final class SupplierProductsViewModel {

    private(set) var products: [ProductModel] = []
    private var lastProductIds: [String] = []

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
                self?.lastProductIds = products.map { $0.id }
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
                let newIds = products.map { $0.id }
                if newIds != self?.lastProductIds {
                    self?.products = products
                    self?.lastProductIds = newIds
                    self?.onDataUpdated?()
                }
            case .failure(let error):
                self?.onError?(
                    error.localizedDescription
                )
            }
        }
    }
}
