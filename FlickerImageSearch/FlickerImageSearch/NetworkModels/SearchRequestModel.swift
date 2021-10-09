//
//  SearchRequestModel.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import Foundation

class SearchRequestModel: BaseRequest {

    var urlComponents: URLComponents

    private enum Constants {

        static let  urlString = "https://api.flickr.com/services/rest/"

        enum Headers {
            static let staticHeaders = [
                "method": "flickr.photos.search",
                "format": "json",
                "api_key": "112502fb2339890e1ef26d1773b45b8d",
                "nojsoncallback": "1"
            ]

            static let perPageItemCountKey = "per_page"
            static let pageKey = "page"
            static let searchQueryKey = "text"
        }
    }

    init?(page: Int, itemsPerPage: Int = 20, searchText: String) {

        guard let urlComponents = URLComponents(string: Constants.urlString),
                urlComponents.url != nil else {
                    return nil
                }

        self.urlComponents = urlComponents

        var queries: [URLQueryItem] = []
        for key in Constants.Headers.staticHeaders.keys {
            queries.append(URLQueryItem(name: key, value: Constants.Headers.staticHeaders[key]))
        }

        queries.append(
            URLQueryItem(name: Constants.Headers.pageKey, value: "\(page)" )
        )
        queries.append(
            URLQueryItem(name: Constants.Headers.perPageItemCountKey , value: "\(itemsPerPage)")
        )
        queries.append(
            URLQueryItem(name: Constants.Headers.searchQueryKey, value: "\(searchText)")
        )

        self.urlComponents.queryItems = queries
    }
}
