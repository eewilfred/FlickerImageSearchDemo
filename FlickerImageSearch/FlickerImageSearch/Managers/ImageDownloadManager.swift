//
//  ImageDownloadManager.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 10/10/2021.
//

import UIKit

extension Notification.Name {

    static let imageDownloadCompleted = Notification.Name(rawValue: "imageDownloadCompleted")
    static let imageDownloadFailed = Notification.Name(rawValue: "imageDownloadFailed")
}

class ImageDownloadManager {

    static let shared = ImageDownloadManager()
    private let imageCache = NSCache<NSString,UIImage>()

    private var fetchInProgress: [URL: URLSessionDataTask] = [:]

    // Items are in same order as shown in UI hence update can happen in same order
    func getImages(photos: [Photo]) {

        photos.forEach { photo in
            if let urlString = photo.urlString,
               let url = URL(string: urlString) {
                _ = getImageForURL(url: url)
            }
        }
    }

    func getImageForURL(url: URL) -> UIImage? {

        // Image already in cache
        if let image = imageCache.object(forKey: url.absoluteString as NSString) {
            return (image)
        }

        // Fetching in progress
        if fetchInProgress[url] != nil {
            return (nil)
        }

        // Image needs to be downloaded
        let dataTask = URLSession.shared.dataTask(with: url)  { (data, _, error) in

            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                self.broadcast(
                    notification: .imageDownloadCompleted,
                    sender: self,
                    userInfo: [url.absoluteString : image]
                )
            } else {
                let errorToberodcasted = error ?? NSError(
                  domain: "No data recived",
                  code: 404,
                  userInfo: nil
                ) as Error
                self.broadcast(
                  notification: .imageDownloadFailed,
                  sender: self,
                  userInfo: [url.absoluteString : errorToberodcasted]
                )
            }
        }
        fetchInProgress[url] = dataTask
        dataTask.resume()
        return (nil)
    }

    func stopImageDownloadTask(url: URL) {

        if let task = fetchInProgress[url] {
            task.cancel()
        }
        fetchInProgress[url] = nil
    }

    private func broadcast(
        notification: Notification.Name,
        sender: Any? = nil,
        userInfo: [String: Any]? = nil
    ) {

        NotificationCenter.default.post(name: notification, object: sender, userInfo: userInfo)
    }
}
