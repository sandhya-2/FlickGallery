//
//  MockNetworkManager.swift
//  FlickGalleryTests
//
//  Created by Sandhya on 06/06/2024.
//

import Foundation
@testable import FlickGallery

/*MockNetworkManager that behaves like NetworkManager for testing ViewModel*/

class MockNetworkManager: NetworkManager {
    
    var mockResult: Any?
    var mockResponse: URLResponse!
    
    var error: NetworkError?
    
    func setModelResult<T: Decodable>(result: Result<T, NetworkError>) {
        self.mockResult = result
    }
    
    override func getModel<T>(_ type: T.Type, url: String) async throws -> Result<T, FlickGallery.NetworkError> where T : Decodable {
            if let result = mockResult as? Result<T, NetworkError> {
                return result
            } else {
                throw NetworkError.mockError
            }
        }
    
    
   /* func getModel<T>(_ type: T.Type, url: String) async throws -> Result<T, FlickGallery.NetworkError> where T : Decodable {
        do {
            let bundle = Bundle(for: MockNetworkManager.self)
            guard let resourcePath = bundle.url(forResource: url, withExtension: "json") else
            {
                throw NetworkError.invalidURL
            }
            let data = try Data(contentsOf: resourcePath)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            throw NetworkError.dataNotFound
        }
    }*/
    
}

// Define a dummy response model for testing purposes
struct DummyResponse: Decodable, Equatable {
    let id: String
}

struct EmptyResponse: Decodable, Equatable {
    
}
