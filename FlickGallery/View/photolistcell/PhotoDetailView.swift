//
//  PhotoDetailView.swift
//  FlickGallery
//
//  Created by Sandhya on 05/06/2024.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    let photoInfo: PhotoInfo
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        HStack {
            detailHeader
        }
        
        ScrollView {
            
            CacheImageView(imageSource: .photo(photo))
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(photo.title)
                    .foregroundColor(Color.theme.redColor)
                    .font(.caption)
                    .fontWeight(.bold)
                    
                
                Text(photoInfo.owner.username ?? "")
                    .font(.subheadline)
                
                
                Text("Uploaded on: \(photo.datetaken )")
                
                
                Text("#\(photo.tags)")
                    .font(.subheadline).padding(1)
                
                Text(photoInfo.tags?.tag.first?.content ?? "")
                
                if let description = photo.description?._content {
                    Text(description)
                        .font(.body)
                        .padding()
                    
                    Spacer()
                }
                
            }.padding()
                .navigationBarBackButtonHidden(true)
            
        }
        

        

        
    }
    
}

extension PhotoDetailView {
    
    private var detailHeader: some View {
        HStack {
            CircleButtonView(iconName: "chevron.left")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("Photo Info")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "info")
                .onTapGesture {
                    print("tap info")
                }
        }.padding(.horizontal)
    }
    
    
    
}
