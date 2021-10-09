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

    var page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    var photo: [Photo]?
}

// MARK: - Photo

struct Photo: Codable {

    let secret: String?
    let server: String?
    let farm: Int?
    let id: String?

    var urlString: String? {

        guard let secret = secret,
              let server = server,
              let farm = farm,
              let id = id else {
                  return nil
              }
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
