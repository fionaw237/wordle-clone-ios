//
//  DictionaryServiceTests.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 14/12/2023.
//

import XCTest
@testable import WordleClone

final class DictionaryServiceTests: XCTestCase {
    
    var sut: DictionaryService!

    override func setUpWithError() throws {
       sut = DictionaryService(httpClient: MockHttpClient())
    }

    override func tearDownWithError() throws {
        sut = nil
    }


}
