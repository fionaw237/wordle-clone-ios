//
//  HttpClient.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import Foundation

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

protocol HttpClientProtocol {
    func fetchData<T: Decodable>(from url: URL) async throws -> [T]
}

// TODO: Handle errors
struct HttpClient: HttpClientProtocol {
    func fetchData<T>(from url: URL) async throws -> [T] where T : Decodable {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return []
        }
        guard let decodedData = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return decodedData
    }
}
