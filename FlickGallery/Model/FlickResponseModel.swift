//
//  PhotoResponse.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

import Foundation

// MARK: - FlickResponse
struct FlickResponse: Codable, Equatable {
    
    let photos: PhotosImage
    let stat: String
    
    static func == (lhs: FlickResponse, rhs: FlickResponse) -> Bool {
        return lhs.photos == rhs.photos
    }
}

// MARK: - Photos
struct PhotosImage: Codable, Equatable, Hashable {
    let page, pages, perpage, total: Int?
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

















/*struct FlickResponse: Codable {
    let photos: FlickrPhotos
}

struct FlickrPhotos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]
}

struct Photo: Codable, Identifiable {
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
    
    
    let id, owner,secret,server :String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily : Int
    let dateupload, datetaken,datetakenunknown: String
    let ownername,iconserver: String
    let iconfarm: Int
    let tags: String
    let description: Description?
    
    
    var imageUrl: URL {
        let urlString = String(format: "\(APIEndpoint.baseImageURL)\(server)/\(id)_\(secret)_w.jpg")
        return  URL(string:urlString )!
    }
    
    
    /*http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg*/
    struct Description: Codable {
        let _content: String
    }
}
*/

