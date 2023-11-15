//
//  LoadMoreCell.swift
//  EssentialFeediOS
//
//  Created by Costa Monzili on 15/11/2023.
//

import UIKit

public class LoadMoreCell: UITableViewCell {

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        contentView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            spinner.heightAnchor.constraint(lessThanOrEqualToConstant: 40)
        ])
        return spinner
    }()

    public var isLoading: Bool {
        get { spinner.isAnimating }
        set { newValue ? spinner.startAnimating() : spinner.stopAnimating() }
    }
}
