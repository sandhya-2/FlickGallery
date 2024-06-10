//
//  MockNetworkManager.swift
//  FlickGalleryTests
//
//  Created by Sandhya on 06/06/2024.
//

import Foundation

@testable import FlickGallery

/*MockNetworkManager that behaves like NetworkManager for testing ViewModel*/

class MockNetworkManager: Networkable {
    
    private var mockResult: Any?
    
    func setResult<T: Decodable>(result: Result<T, NetworkError>) {
        self.mockResult = result
    }
    
    func getModel<T>(_ type: T.Type, url: String) async throws -> Result<T, FlickGallery.NetworkError> where T : Decodable {
        if let result = mockResult as? Result<T, NetworkError> {
            return result
        } else {
            throw NetworkError.mockError
        }
    }
    
}
