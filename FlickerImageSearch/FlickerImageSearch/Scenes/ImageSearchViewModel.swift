//
//  ImageSearchViewModel.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import Foundation

// MARK: - ImageSearchViewModelDelegate

protocol ImageSearchViewModelDelegate: AnyObject {

    func searchResultUpdated()
}

// MARK: - ImageSearchViewModelState

struct ImageSearchViewModelState {

    private enum Constants {

        static let itemsPerPage = 20
    }
    var searchText: String?
    var pageNumber = 1
    var totalPages = 0
    var itemsPerPage = Constants.itemsPerPage
    var photos: [Photo]?

    mutating func reset() {

        searchText = nil
        pageNumber = 1
        totalPages = 0
        itemsPerPage = Constants.itemsPerPage
        photos = nil
    }
}

// MARK: - ImageSearchViewModel

class ImageSearchViewModel {

    var state = ImageSearchViewModelState()
    weak var delegate: ImageSearchViewModelDelegate?

    func searchImages(for text: String) {

        guard !text.isEmpty else { return }

        if text == state.searchText { // fetch next page
            fetchNextpage()
        } else { // new search
            fetchImagesInfo(for: text)
        }
    }

    private func fetchImagesInfo(for text: String) {

        state.reset()
        state.searchText = text
        fetchImagesInfo()
    }

    private func fetchNextpage() {

        state.pageNumber += 1
        fetchImagesInfo()
    }

    private func fetchImagesInfo() {

        if let searchText = state.searchText,
           let request = SearchRequestModel(page: state.pageNumber, searchText: searchText) {

            NetworkManager.shared.start(request: request) { (response: Result<SearchResponseModel>) in

                if let error = response.error {
                    // TODO: HANLDE error
                    return
                }

                self.state.pageNumber = response.result?.photos?.page ?? 0
                self.state.itemsPerPage = response.result?.photos?.perpage ?? self.state.itemsPerPage
                self.state.totalPages = response.result?.photos?.total ?? 0
                if self.state.photos == nil {
                    self.state.photos = response.result?.photos?.photo
                } else {
                    self.state.photos?.append(contentsOf: response.result?.photos?.photo ?? [])
                }
                self.delegate?.searchResultUpdated()
            }
        }
    }
}
