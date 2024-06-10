//
//  UserIDView.swift
//  FlickGallery
//
//  Created by Sandhya on 06/06/2024.
//

import SwiftUI

struct UserIDView: View {
    
    let photo: PhotoElement
    let userId: String
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    detailHeader
                }
                
                ScrollView {
                    
                    
                    LazyVGrid(columns: viewModel.columnGrid, alignment: .center) {
                        
                        let photos = viewModel.getPhotosbyUserID
                        ForEach(photos, id: \.self) { photo in
                            
                            NavigationLink(destination: PhotoDetailView(photo: photo, viewModel: viewModel)) {
                                CacheImageView(imageSource: .photo(photo))
                                    .frame(width: (UIScreen.main.bounds.width - 45) / 3, height: (UIScreen.main.bounds.width - 45) / 3)
                                    .cornerRadius(5)
                            }
                            
                            
                        }
                        
                    }
                    
                }.padding(10)
                    .onAppear{
                        Task {
                            
                            try await viewModel.getPhotosByUser(userId: photo.owner)
                            
                        }
                    }
            }
            
            Spacer()
        }.navigationBarBackButtonHidden(true)
        
        
    }
    
}

#Preview {
    
    UserDetailView(photo: PhotoElement(id: "53543508966", secret: "14d2928f14", server: "65535", farm: 66, owner: "39627107@N07", title: "Blackbird with attitude", ispublic: 1, isfriend: 0, isfamily: 0), viewModel: PhotoViewModel(networkManager: NetworkManager()))
}

extension UserIDView {
    
    private var detailHeader: some View {
        HStack {
            CircleButtonView(iconName: "chevron.left")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("Photos by UserID")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            crossButtom
        }.padding(.horizontal)
    }
    
    private var crossButtom: some View {
        Button {
            
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(14)
                .frame(width: 25, height: 25)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}


