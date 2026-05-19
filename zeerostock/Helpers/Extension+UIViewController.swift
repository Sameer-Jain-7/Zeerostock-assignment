//
//  Extension+UIViewController.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit


private var loadingViewTag = 999999

extension UIViewController {
    
    func showAlert(title: String? = nil ,message: String) {
        
        let alert = UIAlertController(
            title: title ?? "",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

extension UIViewController {

    func showLoading() {
        hideLoading()
        let loadingView = LoadingView()
        loadingView.tag = loadingViewTag
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadingView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            loadingView.alpha = 1
        }
    }

    func hideLoading() {
        guard let loadingView = view.viewWithTag(loadingViewTag) else {
            return
        }
        UIView.animate(
            withDuration: 0.25,
            animations: {
                loadingView.alpha = 0
            }, completion: { _ in
                loadingView.removeFromSuperview()
            }
        )
    }
}
