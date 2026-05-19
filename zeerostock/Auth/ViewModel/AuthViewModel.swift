//
//  AuthViewModel.swift
//  zeerostock
//
//  Created by Sameer Jain on 16/05/26.
//

import Foundation

final class AuthViewModel {
    
    func login(
        email: String,
        password: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {
        
        guard !email.isEmpty,
              !password.isEmpty else {
            return
        }
        
        AuthService.shared.login(
            email: email,
            password: password,
            completion: completion
        )
    }
    
    func signup(
        name: String,
        email: String,
        password: String,
        role: String,
        completion: @escaping(Result<Void, Error>) -> Void
    ) {
        
        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            return
        }
        
        AuthService.shared.signup(
            name: name,
            email: email,
            password: password,
            role: role,
            completion: completion
        )
    }
}
