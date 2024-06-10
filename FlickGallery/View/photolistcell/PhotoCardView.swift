//
//  PhotoListItem.swift
//  FlickGallery
//
//  Created by Sandhya on 04/06/2024.
//

import SwiftUI

struct PhotoCardView: View {
    
    let photo: PhotoElement
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    
    var body: some View {
        
        GroupBox {
            
            VStack(alignment: .leading) {
                
                CacheImageView(imageSource: .photo(photo))
                    .clipped()
                    .padding(2)
                    .padding(.bottom, 2)
                
                HStack {
                    
                    //user icon
                    if let personDetails = viewModel.personDetailsList {
                        HStack {
                            IconView(personDetail: personDetails)
                        }
                    }
                    
                    //userid
                    Text(photo.owner)
                        .font(.caption)
                        .foregroundColor(Color.theme.greenColor)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .padding(.leading, 5)
                }.padding(4)
                
                
                Spacer()
                
            }.padding(.horizontal, 5).onAppear{
                Task {
                    try await viewModel.getPersonDetails(userId: photo.owner)
                    
                }
            }
            
                
        }.padding(5)
            .groupBoxStyle( CardGroupBoxStyle())
        
    }
}



#Preview {
    PhotoCardView(photo: PhotoElement(id: "51678339752", secret: "4c2fb7ec26", server: "65535", farm: 66, owner: "34207648@N07", title: "Gannet collecting nesting material - (Morus bassanus) - 2 clicks for LARGE", ispublic: 1, isfriend: 0, isfamily: 0), viewModel: PhotoViewModel(networkManager: NetworkManager()))
}

struct IconView: View {
    let personDetail: PersonDetails
    var body: some View {
        
        CacheImageView(imageSource: .user(personDetail))
        
    }
}

