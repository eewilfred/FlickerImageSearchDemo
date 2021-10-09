//
//  NetworkManager.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import Foundation

// MARK: - Response

public struct Result<Value> {

    /// The URL request sent to the server
    public let requestURL: URL?

    /// The data returned by the server
    public let data: Data?

    /// Decoded Result
    public let result: Value?

    /// Error received
    public let error: Error?
}

// MARK: - NetworkManager

open class NetworkManager {

    static let shared = NetworkManager()
    let session  = URLSession.shared

    func start<T: BaseResponse>(request: BaseRequest, complition: ((Result<T>) -> Void)?) {

        let handleError = { (errorReceived: Error? , data: Data?, url: URL?) -> Void in

            let error = errorReceived ?? NSError(
                domain: "Generic error",
                code: 0,
                userInfo: nil
            ) as Error
            let result = Result<T>(
                requestURL: url,
                data: data,
                result: nil,
                error: error
            )
            complition?(result)
        }

        guard let url = request.urlComponents.url else {
            assertionFailure("URL is not set for the network call: Logical Error")
            handleError(nil,nil,nil)
            return
        }

        let dataTask = session.dataTask(
            with: url) { ( data, response, error) in
                guard let data = data,
                error == nil else {
                    handleError(error,data,url)
                    return
                }

                do {
                    // PARSE Data
                    let model = try JSONDecoder().decode(T.self, from: data)
                        let result = Result(
                            requestURL: url,
                            data: data,
                            result: model,
                            error: error
                        )
                        complition?(result)
                        return
                } catch let jsonError {
                    // parsing failed
                    handleError(jsonError,data,url)
                }
            }
        dataTask.resume()
    }
}

