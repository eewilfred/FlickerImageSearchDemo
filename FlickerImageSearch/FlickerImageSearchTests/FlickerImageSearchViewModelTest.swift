//
//  FlickerImageSearchViewModelTest.swift
//  FlickerImageSearchViewModelTest
//
//  Created by Edwin Wilson on 09/10/2021.
//

import XCTest
@testable import FlickerImageSearch

class FlickerImageSearchViewModelTest: XCTestCase, ImageSearchViewModelDelegate {

    let viewmodel = ImageSearchViewModel()
    var expectation:  XCTestExpectation?

    override func setUpWithError() throws {

        checkIntialValues()
        viewmodel.delegate = self
        expectation = expectation(description: "image search")
        expectation?.expectedFulfillmentCount = 2
        viewmodel.searchImages(for: "cat")
        waitForExpectations(timeout: 60, handler: nil)
    }

    func testImagesearch() {

        expectation = expectation(description: "image search")
        expectation?.expectedFulfillmentCount = 2
        viewmodel.searchImages(for: "cat")
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertTrue(viewmodel.state.totalPages != 0, "Search is not working as expected")
        XCTAssertTrue(viewmodel.state.photos?.count == 20, "Search is not working as expected") // there will be 20 cats
    }

    func testPaginationWithNoDownload() {

        let lastItemCount = viewmodel.state.photos?.count ?? 0
        viewmodel.updateLastViewedIndex(index: 1)
        XCTAssertTrue(viewmodel.state.lastViewedItemIndex == 1,"lastViewedItemIndex not updated")
        XCTAssertTrue(viewmodel.state.photos?.count == lastItemCount, "Pagination logic failed")

    }

    func testPaginationWithDownload() {

        let lastItemCount = viewmodel.state.photos?.count ?? 0
        expectation = expectation(description: "pagination test")
        viewmodel.updateLastViewedIndex(index: (viewmodel.state.itemsPerPage * viewmodel.state.pageNumber) - 5)
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssertTrue(viewmodel.state.photos?.count ?? 0 > lastItemCount, "Pagination logic failed")
    }

    func testReset() {

        expectation = expectation(description: "reset")
        viewmodel.searchImages(for: "")
        waitForExpectations(timeout: 60, handler: nil)
        checkIntialValues()
    }

    func checkIntialValues() {

        XCTAssertTrue(viewmodel.state.lastViewedItemIndex == 0, "Wrong intilization")
        XCTAssertTrue(viewmodel.state.pageNumber == 1, "Wrong intilization")
        XCTAssertTrue(viewmodel.state.lastViewedItemIndex == 0, "Wrong intilization")
        XCTAssertNil(viewmodel.state.photos, "Wrong intilization")
    }

    func resetSearchResult() {

        expectation?.fulfill()
    }

    func searchResultUpdated() {

        expectation?.fulfill()
    }

    func searchFailed() {
        expectation?.fulfill()
    }

}
