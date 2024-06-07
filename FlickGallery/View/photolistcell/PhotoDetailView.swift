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
    @Environment(\.presentationMode) private var presentationMode
    
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
                   
                
                Text(photoInfo.owner.nsid ?? "")
                    .font(.title3)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        selectedUserID = photoInfo.owner.nsid ?? "NA"
                        idSelected = true
                        
                    }
                
                
                Text("Date taken: \(photoInfo.dates.taken)")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                
            }
        
        
    }
    
    private var middleSection: some View {
        
        VStack(alignment: .leading, spacing: 8){
            
            Text(photoInfo.owner.username ?? "")
                .font(.title3)
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    userNameSelected.toggle()
                    print("tapped")
                }
            
            Text("#\(photoInfo.tags?.tag.first?.content ?? "NA")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(1)
            
            Text("author: \(photoInfo.tags?.tag.first?.authorname ?? "NA")")
                .font(.subheadline)
                .padding(1)
            
            Text(photoInfo.description.content ?? "NA")
                .font(.subheadline)
                
        }
    }
    
   
    
}
