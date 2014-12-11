//
//  PodsJSONServiceTests.swift
//  PodsDemo
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

extension XCTestCase {
    func waitForExpectationsAndFailAfterTimeout(timeout: NSTimeInterval) {
        waitForExpectationsWithTimeout(timeout) {
            if let error = $0 {
                XCTFail("timeout")
            }
        }
    }
}

// integration tests
class PodsJSONServiceTests: XCTestCase {

    func test_PodsAPI_ResultContainsPodsSpecifications() {
        let expectaction = expectationWithDescription("")
        let service = makePodsAPIService()

        service.fetchJSON(["page": 0]) { result in
            expectaction.fulfill()
            switch result {
                case .OK(let data): XCTAssertNotNil(data["result"] as? [NSDictionary])
                case .Error: XCTFail()
            }
        }
        waitForExpectationsAndFailAfterTimeout(5)
    }

    func test_PodsAPI_ResultContainsPagingData() {
        let expectaction = expectationWithDescription("")
        let service = makePodsAPIService()

        service.fetchJSON(["page": 0]) { result in
            expectaction.fulfill()
            switch result {
            case .OK(let data): XCTAssertNotNil(data["number_of_pages"] as? Int)
            case .Error: XCTFail()
            }
        }
        waitForExpectationsAndFailAfterTimeout(5)
    }

    // MARK: -

    private func makePodsAPIService() -> WebJSONService {
        return WebJSONService(baseURLString: "http://localhost:4567/specs", defaultParameters: [String: Any]())
    }
}
