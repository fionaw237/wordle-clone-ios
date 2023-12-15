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
    func fetchData<T: Decodable>(from url: URL, completion: @escaping ([T]) -> Void)
}

// TODO: Handle errors
struct HttpClient: HttpClientProtocol {
    func fetchData<T: Decodable>(from url: URL, completion: @escaping ([T]) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard (response as? HTTPURLResponse)?.statusCode == 200, let data else {
                return
            }
            guard let decodedData = try? JSONDecoder().decode([T].self, from: data) else {
                return
            }
            completion(decodedData)
        }.resume()
    }
}
