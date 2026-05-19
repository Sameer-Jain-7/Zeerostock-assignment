//
//  SceneDelegate.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = UIWindow(windowScene: windowScene)

        checkUserLogin()

        window?.makeKeyAndVisible()
    }

    private func checkUserLogin() {

        // Already logged in
        if let userId = Auth.auth().currentUser?.uid {

            Firestore.firestore()
                .collection("users")
                .document(userId)
                .getDocument { [weak self] snapshot, error in

                    guard let data = snapshot?.data(),
                          let role = data["role"] as? String else {

                        self?.showLogin()
                        return
                    }
                    RoleManager.shared.currentRole = role

                    DispatchQueue.main.async {

                        switch role {

                        case "user":
                            self?.window?.rootViewController = UserTabBarController()

                        case "supplier":
                            self?.window?.rootViewController = SupplierTabBarController()

                        case "super_admin", "product_admin", "auction_admin":
                            self?.window?.rootViewController = AdminTabBarController()

                        default:
                            self?.showLogin()
                        }
                    }
                }

        } else {

            showLogin()
        }
    }

    private func showLogin() {

        window?.rootViewController = UINavigationController(
            rootViewController: LoginViewController()
        )
    }
}
