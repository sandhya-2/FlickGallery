//
//  ErrorView.swift
//  FlickGallery
//
//  Created by Sandhya on 03/06/2024.
//

import SwiftUI

struct PhotoGridView<Content: View>: View {
    let photos: [Photo]
    let photosInfo: [PhotoInfo]
    let columns: [GridItem]
    let destination: (Photo, PhotoInfo) -> Content
    
    init(photos: [Photo], photosInfo: [PhotoInfo], columns: [GridItem], @ViewBuilder destination: @escaping (Photo, PhotoInfo) -> Content) {
        self.photos = photos
        self.photosInfo = photosInfo
        self.columns = columns
        self.destination = destination
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Array(zip(photos, photosInfo)), id: \.0.id) { photo, photoInfo in
                NavigationLink(destination: destination(photo, photoInfo)) {
                    PhotoCardView(photo: photo, userInfo: photoInfo)
                        .padding(10)
                }
            }
        }
    }
    
}


//#Preview {
//    PhotoGridView(photos: [Photo(id: "1", owner: "owner1", secret: "secret1", server: "server1", farm: 1, title: "Title1", ispublic: 1, isfriend: 0, isfamily: 0, dateupload: "", datetaken: "", datetakenunknown: "", ownername: "", iconserver: "", iconfarm: 0, tags: "", description: nil)],
//                  photosInfo: [PhotoInfo(id: "1", secret: "secret1", server: "server1", farm: 1, dateuploaded: "1717688161", isfavorite: 0, license: "0", safetyLevel: "0", rotation: 0, originalsecret: nil, originalformat: nil, owner: Owner(), title: Comments(), description: Comments(), visibility: Geoperms(), dates: Dates(), views: "", editability: Editability(), publiceditability: Editability(), usage: Usage(), comments: Comments(), notes: Notes(), people: People(), tags: Tags(), location: Location(), geoperms: Geoperms(), urls: Urls(), media: "")],
//                  columns: [GridItem(.flexible())]) { photo, photoInfo in
//        Text("Detail View for \(photo.title)")
//    }
//}
