//
//  SearchResultModel.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import Foundation

// MARK: - SearchResultModel

struct SearchResponseModel: BaseResponse {

    let photos: Photos?
    let stat: String?
}

// MARK: - Photos

struct Photos: Codable {

    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let photo: [Photo]?
}

// MARK: - Photo

struct Photo: Codable {

    let secret: String?
    let server: String?
    let farm: Int?
}
