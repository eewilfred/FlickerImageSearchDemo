//
//  ViewController.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import UIKit

class ImageSearchViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        if let request = SearchRequestModel(page: 1, searchText: "cat") {
            NetworkManager.shared.start(request: request) { (result: Result<SearchResponseModel>) in
                print(result.result)
            }
        }
    }
}

