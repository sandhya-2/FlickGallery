//
//  PhotoResponse.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import Foundation

// MARK: - FlickResponse
struct FlickResponse: Codable, Equatable {
    var photos: PhotosImage
    
    static func == (lhs: FlickResponse, rhs: FlickResponse) -> Bool {
        return lhs.photos == rhs.photos
    }
}

// MARK: - Photos
struct PhotosImage: Codable, Equatable, Hashable {
    let photo: [PhotoElement]?
    
    static func == (lhs: PhotosImage, rhs: PhotosImage) -> Bool {
        return lhs.photo == rhs.photo
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(photo)
        }
    
}

// MARK: - Photo
struct PhotoElement: Codable , Hashable, Identifiable {
    let id, secret, server: String
    let farm: Int
    let owner: String
    let title: String
    let ispublic, isfriend, isfamily: Int

    var imageUrl: URL {
        let urlString = String(format: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_w.jpg")
        return  URL(string:urlString )!
    }
   
}
















