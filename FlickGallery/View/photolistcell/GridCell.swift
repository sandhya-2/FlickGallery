//
//  GridCell.swift
//  FlickGallery
//
//  Created by Sandhya on 07/06/2024.
//

import SwiftUI

struct GridCell: View {
    
    let photo: Photo
    
    var body: some View {
        
        VStack {
            GroupBox {
                CacheImageView(imageSource: .photo(photo))
                    .clipped()
                    .shadow(color: Color.black.opacity(0.3),radius: 20, x: 0, y: 10)
                    .padding()
                    .padding(.bottom, 2)
                
                HStack {
                    Text(photo.owner)
                        .font(.callout)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(photo.ownername)
                        .multilineTextAlignment(.leading)
                        .font(.callout)
                        .fontWeight(.semibold)
                }.padding(.horizontal, 15)
                
               Divider()
            }
           
        }.padding(10)
    }
}

//#Preview {
//    GridCell()
//}
