//
//  ViewController.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import UIKit

class ImageSearchViewController: UIViewController {

    let viewModel = ImageSearchViewModel()

    override func viewDidLoad() {

        super.viewDidLoad()
        viewModel.delegate = self
    }
}

// MARK: - ImageSearchViewModelDelegate

extension ImageSearchViewController: ImageSearchViewModelDelegate {

    func searchResultUpdated() {}
}
