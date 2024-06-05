//
//  PhotoResponse.swift
//  FlickGallery
//
//  Created by Sandhya on 31/05/2024.
//

/*The response model of flickr.photos.getInfo */
import Foundation

struct FlickResponse: Codable {
    let photos: FlickrPhotos
}

struct FlickrPhotos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]
}

struct Photo: Codable, Identifiable {
   
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
//        URL(string: "\(APIEndpoint.baseImageURL)\(server)/\(id)_\(secret)_q.jpg")!
        URL(string: "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")!
    }

    
/*http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg*/
    struct Description: Codable {
        let _content: String
    }
}


