//
//  HomeView.swift
//  FlickGallery
//
//  Created by Sandhya on 05/06/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = PhotoViewModel(networkManager: NetworkManager())
    @State var iDselected: Bool = false
    @State var nameSelected: Bool = false
    @State var user_id: String = ""
    
    var body: some View {
        
        
        NavigationStack {
            VStack {
                SearchBarView(searchText: $viewModel.searchString)
                    .padding(4)
                Spacer()
                ScrollView(.vertical) {
                    LazyVStack {
                        let photos = viewModel.filteredPhotos
                        let photosInfo = viewModel.filteredPhotosInfo
                        
                        ForEach(0..<photos.count, id: \.self) { index in
                            if index < photosInfo.count {
                                let photo = photos[index]
                                let photoInfo = photosInfo[index]
                                
                                NavigationLink(destination: PhotoDetailView(photo: photo, photoInfo: photoInfo, idSelected: $iDselected, userNameSelected: $nameSelected, selectedUserID: user_id)) {
                                    PhotoCardView(photo: photo, userInfo: photoInfo)
                                        .padding(10)
                                        
                                }
                            }
                        }
                        
                        if viewModel.currentPage <= viewModel.totalPages {
                            ProgressView()
                                .onAppear {
                                    Task {
                                        await viewModel.loadMorePhotos()
                                    }
                                }
                        }
                    }
                }
                .padding(5)
                .navigationTitle("Photo Gallery")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Text("\(viewModel.filteredPhotos.count) photos in current page \(viewModel.currentPage)")
                    }
                }
               
            }
        }
    }
}

    
#Preview {
    HomeView()
}
    




