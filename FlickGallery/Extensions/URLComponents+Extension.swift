//
//  URLComponents+Extensions.swift
//  FlickGallery
//
//  Created by Sandhya on 03/06/2024.
//

import Foundation

extension URLComponents {
    func baseComponents() -> URLComponents {
        var components = self
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: APIEndpoint.api_key),
            URLQueryItem(name: "format", value: APIEndpoint.format),
            URLQueryItem(name: "nojsoncallback", value: APIEndpoint.nojsoncallback),
            URLQueryItem(name: "safe_search", value: APIEndpoint.safe_search),
            URLQueryItem(name: "extras", value: APIEndpoint.extras)
        ]
        
        return components
    }
    
    // MARK: - URL Building
    
    func buildURLForSearch(searchText: String, page: Int) -> URL {
            var components = baseComponents()
          
            components.queryItems?.append(URLQueryItem(name: "method", value: APIEndpoint.method))
            components.queryItems?.append(URLQueryItem(name: "text", value: searchText))
            components.queryItems?.append(URLQueryItem(name: "tags", value: searchText))
            components.queryItems?.append(URLQueryItem(name: "per_page", value: "20"))
            components.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
//        print("photo url *******\(components)")
            return components.url!
        }
    
    func buildURLForPhotoInfo(photoId: String) -> URL {
        var components = baseComponents()
        components.queryItems?.append(URLQueryItem(name: "method", value: APIEndpoint.methodInfo))
        components.queryItems?.append(URLQueryItem(name: "photo_id", value: photoId))
//        print("photo url *******\(components)")
        return components.url!
    }
}

