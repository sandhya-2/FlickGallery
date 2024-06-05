//
//  CacheImageView.swift
//  FlickGallery
//
//  Created by Sandhya on 02/06/2024.
//

import SwiftUI

enum ImageSource {
    case photo(Photo)
    case photoInfo(PhotoInfo)
}

struct CacheImageView: View {
    
    let imageSource: ImageSource
    let viewModel = PhotoViewModel(networkManager: NetworkManager())
        
    var body: some View {
           switch imageSource {
           case .photo(let photo):
               CacheAsyncImage(url: photo.imageUrl) { phase in
                   switch phase {
                   case .success(let image):
                       image
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(maxWidth: .infinity, maxHeight: 200)
                           .clipped()
                           .cornerRadius(5)
                           .padding()
                       
                   case .failure(_):
                       VStack {
                           Image(systemName: "exclamationmark.triangle")
                               .resizable()
                               .scaledToFit()
                               .frame(maxWidth: .infinity, maxHeight: 200)
                               .padding(5)
                           Text("Failed to load image")
                               .font(.caption)
                               .foregroundColor(.gray)
                       }
                   case .empty:
                       HStack {
                           ProgressView()
                               .progressViewStyle(CircularProgressViewStyle(tint: .red))
                           Spacer()
                       }
                   @unknown default:
                       Image(systemName: "questionmark")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 60, height: 60)
                           .padding(1)
                   }
               }
               .padding(2)

           case .photoInfo(let photoInfo):
               if let url = viewModel.userIconURL(for: photoInfo) {
                   CacheAsyncImage(url: url) { phase in
                       switch phase {
                       case .success(let image):
                           image
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .frame(width: 30, height: 30)
                               .clipShape(Circle())
                               .padding(5)
                           
                           
                       case .failure(_):
                           VStack {
                               Image(systemName: "exclamationmark.triangle")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 50, height: 50)
                                   .padding(5)
//                               Text("Failed to load image")
//                                   .font(.caption)
//                                   .foregroundColor(.gray)
                           }
                       case .empty:
                           HStack {
                               ProgressView()
                                   .progressViewStyle(CircularProgressViewStyle(tint: .red))
                               Spacer()
                           }
                       @unknown default:
                           Image(systemName: "questionmark")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 40, height: 40)
                               .padding(2)
                       }
                   }
                   .padding()
               } else {
                   Image(systemName: "questionmark")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 40, height: 40)
                       .padding(2)
               }
           }
       }
}

#Preview {

    
    CacheImageView(imageSource: .photo(Photo(
        id: "1234567890",
        owner: "ownerID",
        secret: "secretString",
        server: "serverString",
        farm: 1,
        title: "Photo Title",
        ispublic: 1,
        isfriend: 0,
        isfamily: 0,
        dateupload: "2024-06-03",
        datetaken: "2024-06-03 12:00:00",
        datetakenunknown: "0",
        ownername: "Owner Name",
        iconserver: "iconServer",
        iconfarm: 1,
        tags: "tag1,tag2",
        description: nil
    )))
    
}


