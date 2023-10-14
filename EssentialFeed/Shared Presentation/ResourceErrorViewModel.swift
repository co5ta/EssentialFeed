//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Costa Monzili on 29/07/2023.
//

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
