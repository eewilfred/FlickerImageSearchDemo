//
//  BaseRequestModel.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import Foundation

protocol BaseRequest: AnyObject {

    var urlComponents: URLComponents {get set}
}
