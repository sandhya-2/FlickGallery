//
//  GridCell.swift
//  FlickGallery
//
//  Created by Sandhya on 03/06/2024.
//

import SwiftUI

struct GridCell: View {
    
    let photo: PhotoElement
    
    var body: some View {
        
        VStack(alignment: .center) {
            Spacer()
            GroupBox {
                
                CacheImageView(imageSource: .photo(photo))
                    .frame(width: (UIScreen.main.bounds.width - 15), height: (UIScreen.main.bounds.width - 15))
                    .cornerRadius(5)
                
                
            }.padding(10)
            Spacer()
            
        }.padding(10)
    }
}

#Preview {
    GridCell(photo: PhotoElement(id: "51678339752", secret: "4c2fb7ec26", server: "65535", farm: 66, owner: "34207648@N07", title: "Gannet collecting nesting material - (Morus bassanus) - 2 clicks for LARGE", ispublic: 1, isfriend: 0, isfamily: 0))
}
