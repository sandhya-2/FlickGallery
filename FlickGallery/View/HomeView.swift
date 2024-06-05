//
//  HomeView.swift
//  FlickGallery
//
//  Created by Sandhya on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    @State private var searchText = ""
    @State private var activeID: String?
    @State private var lastPhotoID: String?
    
    var body: some View {
        
        VStack {
            
            SearchBarView(searchText: $viewModel.searchString).onChange(of: searchText) { oldValue, newValue in
                print("Search Home text changed: \(newValue)")
                Task {
                    await viewModel.resetAndSearch()
                }

            }
            .padding(4)
            
            ScrollView(.vertical){
                
                LazyVStack {
                    ForEach(Array(zip(viewModel.filteredPhotos, viewModel.photosInfoList)), id: \.0.id) { photo, photoInfo in
                        PhotoCardView(photo: photo, userInfo: photoInfo)
                            .padding(10)
                    }
                   
                   
    
                    if viewModel.currentPage <= viewModel.totalPages {
                        ProgressView()
                            .onAppear{
                                Task {
                                    await viewModel.loadMorePhotos()
                                }
                            }
                    }
                    
                }
                .scrollTargetLayout()
                
            }.scrollTargetBehavior(.paging)
//            .scrollPosition(id: $activeID, anchor: .bottomTrailing)
//                .onChange(of: activeID, { oldValue, newValue in
//                    print(newValue ?? "")
//                })
            
            .safeAreaPadding(5)
            
            //scrollview
            
        }.navigationTitle("Photo Gallery")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text("\(viewModel.filteredPhotos.count) photos count of current \(viewModel.currentPage)")
                }
            }
        
    }
}

#Preview {
    HomeView()
}

struct PhotoCardView: View {
    let photo: Photo
    let userInfo: PhotoInfo
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10) {
            CacheImageView(imageSource: .photo(photo))
                .padding(.bottom, 5)
            let user = userInfo.owner
            
            HStack {
                
                
                
                CacheImageView(imageSource: .photoInfo(userInfo))
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.leading, 5)
                ///User id
                Text((user.nsid ?? ""))
                    .font(.subheadline)
                    .lineLimit(1)
                
            }.padding(5)
            
            //            Text("#\(photo.tags.description)")
            //                .font(.body)
            //                .frame(maxWidth: .infinity, maxHeight: 100).padding()
            //            Text(userInfo.tags?.tag.first?.content ?? "")
            
            
            //            if let tags = userInfo.tags?.tag {
            //                            ForEach(tags, id: \.id) { tag in
            //                                Text("Tag: \(tag.authorname ?? "")")
            //                            }
            //                        }
            //
            
        }.padding()
        
        
    }
}


struct PhotoDetailView: View {
    let photo: Photo
    //    let photoInfo: PhotoUserInfo
    
    
    var body: some View {
        VStack {
            
            AsyncImage(url: photo.imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                    .padding()
            } placeholder: {
                ProgressView()
            }
            
            //            Text(photoInfo.owner.nsid)
            //                .font(.title)
            //
            //            Text("userowner \(photoInfo.owner)")
            //                .font(.subheadline)
            //               if let dateuploaded = photo.dateupload {
            //                   Text("Uploaded on: \(dateuploaded)")
            //               }
            //
            //               if let tags = photo.tags {
            //                   Text("Tags: \(tags)")
            //                       .font(.subheadline)
            //               }
            //               if let description = photo.description?._content {
            //                   Text(description)
            //                       .font(.body)
            //                       .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail View")
        .navigationBarTitleDisplayMode(.inline)
    }
}



