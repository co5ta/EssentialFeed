//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Costa Monzili on 20/06/2023.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
