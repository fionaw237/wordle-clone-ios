//
//  MockHttpClient.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 15/12/2023.
//

import Foundation
@testable import WordleClone

struct MockHttpClient: HttpClientProtocol {
    func fetchData<T>(from url: URL, completion: @escaping ([T]) -> Void) where T : Decodable {
        
    }
}
