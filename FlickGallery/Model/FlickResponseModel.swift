//
//  PhotoResponse.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

/*The response model of flickr.photos.getInfo */
import Foundation

import Foundation

// MARK: - Welcome
struct FlickResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int

    var imageUrl: URL {
        let urlString = String(format: "\(APIEndpoint.baseImageURL)\(server)/\(id)_\(secret)_w.jpg")
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

