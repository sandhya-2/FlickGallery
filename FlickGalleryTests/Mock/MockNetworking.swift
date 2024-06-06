//
//  MockNetworking.swift
//  FlickGalleryTests
//
//  Created by Sandhya on 06/06/2024.
//

import Foundation

@testable import FlickGallery

class MockNetworking: Networking {
    
    var mockData: Data!
    var mockResponse: URLResponse!
    var error: Error?
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if error != nil {
            throw error!
        }
        return (mockData, mockResponse)
    }
}
