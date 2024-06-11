//
//  APIEndpoint.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import Foundation

struct APIEndpoint {
    private var baseURL = "https://www.flickr.com/services/rest/"
    private var api_key = "cf3607d26a926a17c5bdba4eb13a31d7"
    private var queryString = "&format=json&nojsoncallback=1"
    private var safe_search = "1"
    
    mutating func urlString(method: String, params: String) -> String {
        return ("\(baseURL)?method=\(method)&api_key=\(api_key)\(params)\(queryString)")
    }
    
    
}

/*
 
 https://www.flickr.com/services/rest/?
 method=flickr.photos.search&
 api_key=f0f4126da4d8f57b59654995d2a8adf4&
 format=json&
 nojsoncallback=1&
 text=yorkshire
 */
