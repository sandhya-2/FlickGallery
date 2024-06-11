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
    @State var userId: String = ""
    @State var userName: String = ""
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .center) {
                Text("Photo Gallery")
                    .font(.headline)
                    .fontWeight(.heavy)
            }.padding()
            .foregroundColor(Color.theme.accent)
            
            
        
            VStack {
                SearchBarView(searchText: $viewModel.searchString)
                    .padding(4)
                    .onChange(of: viewModel.searchString) { oldValue, newValue in
                        print(newValue)
                        Task {
                                try await viewModel.getPhotos(searchText: newValue)
                           
                        }
                    }
                
                Spacer()
                
                ScrollView(.vertical) {
                    LazyVStack {
                        
                       
                        let filterPhotos = viewModel.photoElementList
                        
                        
                        
                        ForEach(filterPhotos, id: \.id) { photo in
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                PhotoCardView(photo: photo)
                                    .padding(10)
                            }
                        }
                        
                    }
                }
                .padding()
                
            }
            .padding(.horizontal, 5)
        }
        .onAppear{
            Task {
                try await viewModel.getPhotos(searchText: viewModel.searchString)
            }
        }
        .onSubmit {
            Task {
                try await viewModel.getPhotos(searchText: viewModel.searchString)
            }
        }
        
        
    }
}


#Preview {
    HomeView()
}





