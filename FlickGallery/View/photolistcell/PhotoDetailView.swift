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
    @Binding var idSelected: Bool
    @Binding var userNameSelected: Bool
    @State var selectedUserID: String = ""
    @State var selectedUsername: String = ""
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        HStack {
            detailHeader
        }
        
        ScrollView {
            
            VStack {
                
                imageSection
                    .shadow(color: Color.black.opacity(0.3),radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    middleSection
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                
                
            }.padding()
                .navigationBarBackButtonHidden(true)
                .sheet(isPresented: $idSelected) {
                    UserIDView() 
                        .interactiveDismissDisabled()
                    
                }
                
                .sheet(isPresented: $userNameSelected){
                    UserNameView() 
                        .interactiveDismissDisabled()
                }
                
            Spacer()
        }.interactiveDismissDisabled()
        .ignoresSafeArea()
        
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
    
    private var imageSection: some View  {
        
        CacheImageView(imageSource: .photo(photo))
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width, height: 300)
        
    }
    
    private var titleSection: some View {
      
            VStack(alignment: .leading,spacing: 8) {
                Text(photo.title)
                    .foregroundColor(Color.theme.redColor)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                                
                Text("user_id: \(photoInfo.owner.nsid ?? "NA")")
                    .font(.title3)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        selectedUserID = photoInfo.owner.nsid ?? "NA"
                        idSelected = true
                        
                    }
                
                Text("Username: \(photoInfo.owner.username ?? "NA")")
                    .font(.title3)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        userNameSelected.toggle()
                        print("tapped")
                    }
                
                Text("Date taken: \(photo.datetaken)")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                
            }
        
        
    }
    
    private var middleSection: some View {
        
        VStack(alignment: .leading, spacing: 8){
            
            Text("#\(photo.tags)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(1)
            
            Text("#\(photoInfo.tags?.tag.first?.content ?? "NA")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(1)
            
            Text("Author: \(photoInfo.tags?.tag.first?.authorname ?? "NA")")
                .font(.subheadline)
                .padding(1)
            
            Text(photo.description?._content ?? "NA")
                .font(.subheadline)
                
        }
    }
    
   
    
}
