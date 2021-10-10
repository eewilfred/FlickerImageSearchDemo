//
//  ImageSearchPresentation.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 10/10/2021.
//

import Foundation

struct ImageSearchPresentation {

    enum Sections: Int, CaseIterable {

        case main
    }

    var imageCellPresentations: [ImageSearchCellPresentation] = []

    mutating func update(state: ImageSearchViewModelState) {

        let cellPresentations: [ImageSearchCellPresentation] = state.photos?.compactMap({ photo in
            if let url = photo.urlString {
                return ImageSearchCellPresentation(imageURLString: url)
            }
            return nil
        }) ?? []
        imageCellPresentations.append(contentsOf: cellPresentations)
    }

    mutating func resetPresentation() {

        imageCellPresentations = []
    }
}
