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
    
    func get(url: URL) async throws -> Data {
        do {
            let bundle = Bundle(for: MockNetworkManager.self)
            guard let resourcePath = bundle.url(forResource: url.absoluteString, withExtension: "json") else
            {
                throw NetworkError.invalidURL            }
            let data = try Data(contentsOf: resourcePath)
            return data
        } catch {
            throw NetworkError.dataNotFound
        }
    }
}
