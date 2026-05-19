//
//  Extension+String.swift
//  zeerostock
//
//  Created by Sameer Jain on 17/05/26.
//

import Foundation

public extension String {
    func localiz(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
