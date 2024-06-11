//
//  PhotoDetailView.swift
//  FlickGallery
//
//  Created by Sandhya on 05/06/2024.
//

import SwiftUI

struct PhotoDetailView: View {
    
    let photo: PhotoElement
    @State private var hovered = false
    @State private var showUserDetail = false
    
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        VStack {
            HStack {
                detailHeader
                
            }
            ScrollView {
                
                VStack{
                    
                    imageSection .shadow(color: Color.black.opacity(0.3),radius: 20, x: 0, y: 10)
                        .padding(2)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        titleSection
                            .padding(5)
                        
                        UserDetailView(photo: photo, viewModel: viewModel)
                            .padding(.bottom, 2)
                        Divider()
                        
                        MiddleSectionView(viewModel: viewModel)
                        Spacer()
                        
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    
                }.onAppear {
                    Task {
                        
                        try await viewModel.getPhotoDetail(photoId: photo.id)
                    }
                    
                }
                
            }.interactiveDismissDisabled()
                .ignoresSafeArea()
        }.navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showUserDetail) {
                UserIDView(photo: photo, userId: photo.owner)
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
                .padding(.bottom, 5)
            
            /* Navigate to list of photos by the userid*/
            Text(photo.owner)
                .font(.title3)
                .foregroundStyle(hovered ? Color.theme.greenColor : Color.theme.secondaryText)
                .scaleEffect(hovered ? 1.1 : 1.0)
        }.onTapGesture {
            withAnimation{
                hovered.toggle()
                showUserDetail.toggle()
            }
            
        }
        
    }
    
}

struct MiddleSectionView: View {
    @ObservedObject var viewModel: PhotoViewModel
    let columnGrid = [GridItem(.adaptive(minimum: 120))]
    
    
    var body: some View {
        VStack {
            if let tags = viewModel.photoDetailsList?.photo?.tags?.tag {
                
                LazyVGrid(columns: columnGrid, spacing: 10) {
                    
                    ForEach(tags, id: \.id) { tag in
                        HStack {
                            Text("#\(tag.raw)")
                                .font(.caption)
                                .fixedSize()
                        }
                        .padding(4)
                        .background(
                            Capsule()
                                .stroke(Color.theme.accent)
                                .shadow(color: Color.black.opacity(0.3),radius: 20, x: 0, y: 10)
                                .background(Capsule().fill(Color.teal.opacity(0.1))).padding(2)
                            
                        )
                        .padding(6)
                    }
                    
                }.padding()
            }
        }
        
    }
}


