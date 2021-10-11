//
//  ImageDownloadManagerTest.swift
//  FlickerImageSearchTests
//
//  Created by Edwin Wilson on 11/10/2021.
//

import XCTest
@testable import FlickerImageSearch

class ImageDownloadManagerTest: XCTestCase {

    let imageURL =  "http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg"
    var url: URL!
    var expectation:  XCTestExpectation?

    var image: UIImage?


    override func setUpWithError() throws {

        guard let url = URL(string: imageURL) else {
            XCTFail("URL not valid")
            return
        }
        self.url = url

    }

    func testImageDownload() {

        addObserver()
        expectation = expectation(description: "image download")
        _ = ImageDownloadManager.shared.getImageForURL(url: self.url)
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertNotNil(image)
        image = nil
    }

    func testImageCacheing() {

        addObserver()
        expectation = expectation(description: "image download")
        _ = ImageDownloadManager.shared.getImageForURL(url: self.url)
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertNotNil(image)
        image = nil
        let cachedImage = ImageDownloadManager.shared.getImageForURL(url: self.url)
        XCTAssertNotNil(cachedImage)
    }

    private func addObserver() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleImageUpdates(notification:)),
            name: .imageDownloadCompleted,
            object: nil
        )
    }

    @objc private func handleImageUpdates(notification: Notification) {

        image = notification.userInfo?[imageURL] as? UIImage
        expectation?.fulfill()
    }
}
