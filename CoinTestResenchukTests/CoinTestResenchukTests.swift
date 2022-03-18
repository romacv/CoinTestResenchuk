//
//  CoinTestResenchukTests.swift
//  CoinTestResenchukTests
//
//  Created by Roman R. on 3/16/22.
//

import XCTest
@testable import CoinTestResenchuk

class CoinTestResenchukTests: XCTestCase {
    
    func testApiServiceAssets() {
        let expectation = self.expectation(description: "Loading...")
        let apiService = APIService()
        let limit = 10
        var itemsCount = 0
        apiService.getAssets(type: Assets.CoinResponse.self,
                             search: "",
                             limit: limit,
                             offset: 0) { success in
            itemsCount = success.data?.count ?? 0
            expectation.fulfill()
        } withError: { err in
        }
        
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(itemsCount, limit, "Loaded \(itemsCount) items.")
        
    }
    
    func testApiServiceWatchlist() {
        let expectation = self.expectation(description: "Loading...")
        let apiService = APIService()
        var itemsCount = 0
        let ids = ["bitcoin", "ethereum"]
        apiService.getAssetsByIds(type: Assets.CoinResponse.self,
                             ids: ids) { success in
            itemsCount = success.data?.count ?? 0
            expectation.fulfill()
        } withError: { err in
        }
        
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(itemsCount, ids.count, "Loaded \(itemsCount) items.")
        
    }
    
}
