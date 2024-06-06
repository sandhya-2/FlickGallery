//
//  APIEndpoint.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import Foundation

enum APIEndpoint {
  
    static let baseURL = "https://www.flickr.com/services/rest/"
    static let method = "flickr.photos.search"
    static let methodInfo = "flickr.photos.getInfo"
    static let api_key = "f0f4126da4d8f57b59654995d2a8adf4"
    static let format = "json"
    static let nojsoncallback = "1"
    static let safe_search = "1"
    static let per_page = ""
    static let extras = "tags,owner_name,icon_server,date_upload,date_taken,description"
   
    static let baseImageURL = "https://live.staticflickr.com/"


}


/*
 
 https://www.flickr.com/services/rest/?
 method=flickr.photos.search&
 api_key=f0f4126da4d8f57b59654995d2a8adf4&
 format=json&
 nojsoncallback=1&
 text=yorkshire
 */
