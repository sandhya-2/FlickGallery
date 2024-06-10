//
//  NetworkManager.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import Foundation

protocol Networkable {

    func getModel<T: Decodable>(_ type: T.Type, url: String) async throws -> Result<T, NetworkError>
}

class NetworkManager: Networkable {
    
    func getModel<T: Decodable>(_ type: T.Type, url: String) async throws -> Result<T, NetworkError> {

        guard let url = URL(string: url) else { throw NetworkError.invalidURL }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.dataNotFound
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                print(decodedResponse)
                return .success(decodedResponse)
            } catch {
                return .failure(NetworkError.parsingError)
            }
        }
}
