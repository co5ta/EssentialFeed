//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Costa Monzili on 23/07/2023.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
